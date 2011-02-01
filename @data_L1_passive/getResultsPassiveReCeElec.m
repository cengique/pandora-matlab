function results = getResultsPassiveReCeElec(pas, props)

% getResultsPassiveReCeElec - Estimates passive cell params based on Re Ce electrode model.
%
% Usage:
% results = getResultsPassiveReCeElec(pas, props)
%
% Parameters:
%   pas: A data_L1_passive object.
%   props: Structure with optional properties.
%     stepNum: Voltage pulse to be considered (default=1).
%     traceNum: Trace number ti be analyzed (default=1).
%     delay: Current response delay from voltage step (default=calculated).
%     gL: Leak conductance (default=calculated).
%     EL: Leak reversal (default=calculated).
%     minResnorm: Lowest resnorm to accept (default=0.04).
%     minRe: Lowest Re value accepted.
%
% Returns:
%   Re: Series resistance [MOhm].
%   Cm: Cell capacitance [nF].
%
% Description:
%   Integrates current response and divides by voltage difference to get
% capacitance. Membrane charge time constant is series resistance times
% capacitance. I=Cm*dV/dt+(V-EL)*gL
%
% See also: 
%
% $Id: getResultsPassiveReCeElec.m 896 2007-12-17 18:48:55Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/01/06

% Copyright (c) 2011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

props = defaultValue('props', struct);
min_resnorm = getFieldDefault(props, 'minResnorm', 0.04);
min_Re = getFieldDefault(props, 'minRe', 50);

results = struct;

if nargin == 0 % Called with no params or empty object
  results.Re = NaN;
  results.Cm = NaN;
  results.delay = NaN;
  results = mergeStructs(results, getParamsStruct(param_Re_Ce_cap_leak_act_int_t(nan(7,1))));
  results.resnorm=NaN;
  return;
end

pas_res = calcSteadyLeak(pas);

if pas_res.gL > 0.025
  warning(['gL = ' num2str(pas_res.gL) ' uS is quite large. Expect estimation ' ...
                      'errors for gL and offset parameters.']);
end

delay = calcDelay(pas);

[Re Cm] = calcReCm(pas, mergeStructs(props, mergeStructs(struct('delay', delay), pas_res)));

if Re < min_Re
    warning(['Re=' num2str(Re) ' MOhm too large, setting to minimum 50 MOhm.']);
    Re = max(Re, min_Re); % limit
end

% TODO: 
% - recalculate gL based on Re estimate
% - iterate once more to find a new Re estimate afterwards

results.Re = Re;
results.Cm = Cm;
results.delay = delay;

capleakReCe_f = ...
    param_Re_Ce_cap_leak_act_int_t(...
      struct('Re', Re, 'Ce', 1.2e-3, 'gL', pas_res.gL, ...
             'EL', pas_res.EL, 'Cm', Cm, 'delay', delay, 'offset', pas_res.offset), ...
      ['cap, leak, Re and Ce (int)'], ...
      struct('parfor', 1));

a_md = ...
    model_data_vcs(capleakReCe_f, pas.data_vc, ...
                   [ pas.data_vc.id ': capleak, Re, Ce est']);
plotFigure(plotDataCompare(a_md, ' - integral method', struct('zoom', 'act')));

a_md.model_f.Vm = setProp(a_md.model_f.Vm, 'selectParams', ...
                                             {'Re', 'Ce', 'Cm', 'delay'});

runFit([1 -1 10], 'after fit');

if results.resnorm > min_resnorm
    warning(['fit failed, resnorm too large: ' num2str(results.resnorm) '. Doing a narrow fit...' ]);
    % fit very narrow range after step
    runFit([1 -1 2], '2nd fit (narrow)');
    if results.resnorm > min_resnorm
        error(['narrow fit failed, resnorm too large: ' num2str(results.resnorm) ]);
    else
        % do full fit again
        warning(['narrow fit improved, doing a full fit again.' ]);
        runFit([1 -1 10], '3rd fit (full)');
        assert(results.resnorm < min_resnorm);
    end
end

function runFit(fitrange, str)
  a_md = fit(a_md, ...
             '', struct('fitRangeRel', fitrange, ...
                        'dispParams', 5,  ...
                        'dispPlot', 0, ...
                        'optimset', ...
                        struct('Display', 'iter')));
  results = mergeStructs(results, getParamsStruct(a_md.model_f));

  % reveal fit results
  results.resnorm = a_md.model_f.props.resnorm;
  plotFigure(plotDataCompare(a_md, [ ' - ' str ], struct('zoom', 'act')));

end
end