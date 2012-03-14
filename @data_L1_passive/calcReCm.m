function [Re Cm peak_mag] = calcReCm(pas, props)

% calcReCm - Estimates series resistance and membrane capacitance from membrane charging transient.
%
% Usage:
% [Re Cm peak_mag] = calcReCm(pas, props)
%
% Parameters:
%   pas: A data_L1_passive object.
%   props: Structure with optional properties.
%     stepNum: Voltage pulse to be considered (default=1).
%     traceNum: Trace number to be analyzed (default=1).
%     delay: Current response delay from voltage step (default=calculated).
%     gL: Leak conductance [uS] (default=calculated).
%     EL: Leak reversal [mV] (default=calculated).
%     offset: Amplifier offset [nA] (default=calculated).
%     compCap: Emulate compensation of this much capacitance [pF]. If a
%     		two-element vector, use it as series resistance as in [Cm_pF Re_MO].
%     ifPlot: If 1, create a plot for debugging that shows the current
%      	      integral, time constant point (red star) and the leak (dashed line).
%
% Returns:
%   Re: Series resistance [MOhm].
%   Cm: Cell capacitance [nF].
%   peak_mag: Peak current [same units as in pas]
%
% Description:
%   Integrates current response and divides by voltage difference to get
% capacitance. Membrane charge time constant is series resistance times
% capacitance. I=Cm*dV/dt+(V-EL)*gL
%
% See also: 
%
% $Id: calcReCm.m 896 2007-12-17 18:48:55Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/01/04

% Copyright (c) 2011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% BUG: this is oversimplified! it's not one exp curve!
% 

if nargin == 0 % Called with no params
  error('Need object.');
end

vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

% TODO: make sure step num < -60 mV 
% (getResultsPassiveReCeElec only sends those)
props = defaultValue('props', struct);
trace_num = getFieldDefault(props, 'traceNum', 1);
step_num = getFieldDefault(props, 'stepNum', 1);
delay = getFieldDefault(props, 'delay', calcDelay(pas, props));

% check current units
nA_scale = pas.data_vc.i.dy / 1e-9;

pas_res = struct;
if ~ isfield(props, 'gL') || ~ isfield(props, 'EL')  || ~ isfield(props, 'offset')
  pas_res = calcSteadyLeak(pas, props);
else
 pas_res.gL = getFieldDefault(props, 'gL', NaN);
 pas_res.EL = getFieldDefault(props, 'EL', NaN);
 pas_res.offset = getFieldDefault(props, 'offset', NaN);
end

% fake capacitance compensation
if isfield(props, 'compCap')
  if isa(props.compCap, 'param_func')
    capleak_f = props.compCap;
  elseif length(props.compCap) > 1 % with Re
    capleak_f = ...
        param_Re_Ce_cap_leak_act_int_t(struct('gL', 0, 'EL', 0, 'Ce', 1e-3 * nA_scale, ...
                                              'Re', props.compCap(2) / nA_scale, ...
                                              'Cm', props.compCap(1)*1e-3 * nA_scale, ...
                                              'delay', delay, 'offset', pas_res.offset / nA_scale), ...
                                       'amplifier Re-cap comp', ...
                                       struct);
  else
    capleak_f = ...
        param_cap_leak_int_t(struct('gL', 0, 'EL', 0, 'Cm', props.compCap*1e-3*nA_scale, ...
                                    'delay', delay, 'offset', pas_res.offset/nA_scale), ...
                             'amplifier cap comp', ...
                             struct);
  end
  % simulate model
  cap_md = ...
      model_data_vcs(capleak_f, pas.data_vc, ...
                     [ pas.data_vc.id ': cap comp']);
  % add to I
  orig_i = pas.data_vc.i;
  pas.data_vc.i = pas.data_vc.i + cap_md.model_vc.i;

  if isfield(props, 'ifPlot') || verbose
    plotFigure(plot_superpose({...
      plot_abstract(orig_i, 'orig data', struct), ...
      plot_abstract(cap_md.model_vc.i, 'sim cap comp'), ...
      plot_abstract(pas.data_vc.i, 'combined')}));
  end
end

% mark the whole voltage step
dt = pas.data_vc.trace.dt * 1e3;
start_dt = pas.data_vc.time_steps(step_num) + round(delay/dt);
if step_num < length(pas.data_vc.time_steps)
  end_dt = pas.data_vc.time_steps(step_num + 1);
else
  end_dt = size(pas.data_vc.i.data, 1);
end

% look at peak capacitive artifact and its half-width as an estimate
% for until when to integrate
peak_vc = calcCurPeaks(pas.data_vc, step_num + 1, ...
                       struct('pulseStartRel', max(0, delay), ...
                              'pulseEndRel', [(step_num + 2) min((end_dt - pas.data_vc.time_steps(step_num))*dt, 50)]));
peak_mag = peak_vc.props.iPeaks(trace_num);
peak_halfmag = peak_mag / 3;
if peak_halfmag < 0
  half_time = ...
      find(peak_vc.i.data(start_dt:end_dt, trace_num) < peak_halfmag);
else
  half_time = ...
      find(peak_vc.i.data(start_dt:end_dt, trace_num) > peak_halfmag);
end

% if there are multiple peaks!
half_discont = find(diff(half_time) > 1);
if ~isempty(half_discont)
  if length(half_discont) > 1 && half_discont(1) < 2
    % skip artifact that may appear at the end of first time step
    half_discont = half_discont(2);
  else
    % first discontinuity should indicate the end of first peak
    half_discont = half_discont(1);
  end
  half_time = half_time(half_discont - 1);
else
  half_time = half_time(end);
end

% choose a multiple of half-width
end_dt = min(start_dt + 10*half_time(end) - 1, size(pas.data_vc.i.data, 1));

% take the initial (peak) value of I as initial condition and estimate Re
% I0=(Vc-V0)/Re
deltaV = diff(pas.data_vc.v_steps(step_num:step_num+1, trace_num));
Re = deltaV / nA_scale / peak_mag;

assert(Re > 0);

% estimate of final leak
Ileak = ((pas.data_vc.v_steps(step_num+1, trace_num) - pas_res.EL) * ...
         pas_res.gL + pas_res.offset) * nA_scale;

% current at t=tau (use estimate of Re)
Itau = -Ileak + (deltaV/nA_scale/Re + Ileak/(1+Re*pas_res.gL)) * exp(-1);

% find time constant
Icap = pas.data_vc.i.data(start_dt:end_dt, trace_num);
[t_tmp t_max] = max(abs(Icap));
t_change = find(abs(Icap) < abs(Itau));
assert(~ isempty(t_change), 'Cannot find time constant point?');

t_change = t_change(t_change > t_max);
assert(~ isempty(t_change), 'Cannot find peak?');

timeconstant = t_change(1);

Cm = timeconstant * dt/ Re;

assert(Cm > 0 && Cm < 1e3, ...
       [ 'Cm=' num2str(Cm) ' nF out of range!']);

if isfield(props, 'ifPlot') || verbose
  Iideal = exp(-(0:(length(Icap) - 1))*dt)*(peak_mag - Ileak) + Ileak;
  plotFigure(...
    plot_abstract({(start_dt:end_dt)*dt, Icap, (start_dt + timeconstant) * dt, Icap(timeconstant), '*r', ...
                  (start_dt:end_dt)*dt, Iideal, '--g', (start_dt:end_dt)*dt, [Icap(2:end); Icap(end)] - Iideal(:), '-.k'}, ...
                  {'time [ms]', ['I [nA] / ' num2str(nA_scale)]}, '', {'recorded', 't=\tau', 'exp(-t/\tau)', 'sub'}, ...
                  'plot', ...
                  struct('axisLimits', ...
                         [start_dt*dt + [-1 3*Re*Cm] NaN NaN], ...
                         'fixedSize', [2.5 2])));
end

end
