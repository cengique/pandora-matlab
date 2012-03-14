function res = calcSteadyLeak(pas, props)

% calcSteadyLeak - Calculates passive parameter values based on initial and steady-state values after pulse.
%
% Usage:
% results = calcSteadyLeak(pas, props)
%
% Parameters:
%   pas: A data_L1_passive object.
%   props: Structure with optional properties.
%     stepNum: Voltage pulse to be considered (default=1).
%     traceNum: Trace number to be analyzed (default=1).
%     calcOffsetWithEL: Calculate a manual offset using this EL value [mV]. 
%     calcSealLeakWithEL: Calculate a separate electrode seal leak
%     		 using this EL value [mV].
%     offset: Specify manual offset [nA] (default=0).
%     ifPlot: If 1, create a plot for debugging that shows the leak (dashed line).
%
% Returns:
%  results: a structure with the following:
%   gL: Leak conductance [uS].
%   EL: Leak reversal [mV].
%   offset: Manual current offset applied [nA].
%
% Description:
%   Calculates membrane and electrode seal leak gL, EL and manual offset values.
%
% See also: 
%
% $Id: calcSteadyLeak.m 896 2007-12-17 18:48:55Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/12/30

% Copyright (c) 2010 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 % Called with no params
  error('Need object.');
end

vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

props = defaultValue('props', struct);
trace_num = getFieldDefault(props, 'traceNum', 1);
step_num = getFieldDefault(props, 'stepNum', 1);

% check current units
nA_scale = pas.data_vc.i.dy / 1e-9;

res = struct;

% calculate gL from initial and after pulse steady levels
res.gL = diff(pas.data_vc.i_steps(step_num:(step_num+1), trace_num)) * nA_scale / ...
         diff(pas.data_vc.v_steps(step_num:(step_num+1), trace_num));

% effective EL
res.EL = pas.data_vc.v_steps(step_num, trace_num) - ...
         pas.data_vc.i_steps(step_num, trace_num) * nA_scale / res.gL;

% default
res.offset = 0;

if isfield(props, 'calcOffsetWithEL')
  res.EL = props.calcOffsetWithEL;

  % resolve offset last
  res.offset = pas.data_vc.i_steps(step_num, trace_num) * nA_scale - ...
      (pas.data_vc.v_steps(step_num, trace_num) - res.EL) * res.gL;
elseif isfield(props, 'calcSealLeakWithEL')
  res.ELm = props.calcSealLeakWithEL;
    
  % see k-channel.lyx/pdf appendix
  res.gLm = res.gL * res.EL / res.ELm;
  res.gS = res.gL - res.gLm;
end

% by default return effective EL

if isfield(props, 'ifPlot')  || verbose
  dt = pas.data_vc.trace.dt * 1e3;
  start_dt = pas.data_vc.time_steps(step_num);
  if step_num < length(pas.data_vc.time_steps)
  end_dt = pas.data_vc.time_steps(step_num + 1);
  else
  end_dt = size(pas.data_vc.i.data, 1);
  end
  I2 = ((pas.data_vc.v.data(:, trace_num) - res.EL) * res.gL + res.offset) ...
       / nA_scale;
  plotFigure(plot_superpose({...
    plot_abstract(setLevels(pas.data_vc, trace_num), '', struct('onlyPlot', 'i')), ...
    plot_abstract({(1:size(pas.data_vc.i.data, 1))*dt, I2, '--k'}, ...
                  {}, '', {'est. leak'}, 'plot')}));
end


end


