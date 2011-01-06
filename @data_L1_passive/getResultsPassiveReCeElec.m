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

results = struct;

if nargin == 0 % Called with no params or empty object
  results.Re = NaN;
  results.Cm = NaN;
  results.delay = NaN;
  results = mergeStructs(results, getParamsStruct(param_Re_Ce_cap_leak_act_int_t(nan(7,1))));
  return;
end

[gL, EL, offset] = calcSteadyLeak(pas);
% $$$ gL = 5.8943e-05 uS
% $$$ EL = -80 mV
% $$$ offset = 5.0336e-04 nA
   
delay = calcDelay(pas);
% delay = 0.5 ms

[Re Cm] = calcReCm(pas, struct('delay', delay, 'gL', gL, 'EL', EL));
% $$$ Cm = 0.0057
% $$$ Re = 183.16
% => Re kinda consistent w before, Cm a bit high. prolly because it
% includes Ce. should be good as starting point for fits.
% TODO: 
% - make getresults func that first run these and then a fit
% - run test with surrogate data
% - put a sanity limit on resnorm, say fit failed

results.Re = Re;
results.Cm = Cm;
results.delay = delay;

capleakReCe_f = ...
    param_Re_Ce_cap_leak_act_int_t(...
      struct('Re', Re, 'Ce', 6e-5, 'gL', gL, ...
             'EL', EL, 'Cm', Cm, 'delay', delay, 'offset', offset), ...
      ['cap, leak, Re and Ce (int)'], ...
      struct('parfor', 1));

a_md = ...
    model_data_vcs(capleakReCe_f, pas.data_vc, ...
                   ['capleak, ' ...
                    'Re, Ce est']);
plotFigure(plotDataCompare(a_md, ', cap estimate with integral'));

a_md.model_f.Vm = setProp(a_md.model_f.Vm, 'selectParams', ...
                                             {'Re', 'Ce', 'Cm', 'delay'});

a_md = fit(a_md, ...
           '', struct('fitRangeRel', [1 -1 20], ...
                      'dispParams', 5,  ...
                      'dispPlot', 0, ...
                      'optimset', ...
                      struct('Display', 'iter')));

plotFigure(plotDataCompare(a_md, ', estimate after fitting model'));

results = mergeStructs(results, getParamsStruct(a_md.model_f));
