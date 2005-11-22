function [a_tau, da_inf] = spikeAmpSlope(a_spikes, a_trace, a_period)

% spikeAmpSlope - Calculates the time constant and steady-state value
%		      of the spike amplitude for slow inactivating decays.
%
% Usage:
% [a_tau, da_inf] = spikeAmpSlope(a_spikes, a_trace, a_period)
%
% Description:
%   Parameters:
%	a_spikes: A spikes object.
%	a_trace: A trace object.
%	a_period: The desired period (optional)
%
%   Returns:
%	a_tau: Approximate amplitude decay constant.
%	da_inf: Delta change in final spike peak value from initial.
%
% See also: period, spikes, trace
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/15

%# By default apply to the whole of s, t
if ~ exist('a_period')
  a_period = periodWhole(s);
  s = a_spikes;
  t = a_trace;
else
  s = withinPeriod(a_spikes, a_period);
  t = withinPeriod(a_trace, a_period);
end

if length(s.times) == 0
  a_tau = NaN;
  da_inf = NaN;
  return;
end

%# Conversion factors
mV_factor = 1e3 * get(t, 'dy');
ms_factor = 1e3 * get(t, 'dt');

%#plot(t);
%#hold on;
%#plot(s);
%#stem(s.times * ms_factor, 40 * ones(size(s.times)), 'r.');
%#hold off;

data = get(t, 'data');
peak_vals = data(s.times) * mV_factor;

%# Get linear approximation to see the slope
[pcoefs serr ] = polyfit(s.times', peak_vals, 1);

if pcoefs(1) < 0 
  %# Assumptions:
  [a_max a_max_idx] = max(peak_vals);
  %# Mean of last few peak values
  da_inf = a_max - mean(peak_vals(max(1, end - 4):end));

  decay_constant_threshold = a_max - da_inf * (1 - exp(-1));

  recover_times = find(peak_vals > decay_constant_threshold);
  
  if length(recover_times) > 0
    a_tau = (s.times(recover_times(end)) - s.times(a_max_idx)) * ms_factor;
  else
    a_tau = NaN;
  end
else
  da_inf = NaN;
  a_tau = NaN;
end

