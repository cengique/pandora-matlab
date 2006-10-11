function [base_width, half_width, half_Vm, fall_time, min_idx, min_val, ...
	  max_ahp, ahp_decay_constant, dahp_mag, dahp_idx] = ...
      calcWidthFall(s, max_idx, max_val, init_idx, init_val)

% calcWidthFall - Calculates the spike width and fall information of the 
%		spike_shape, s. 
%
% Usage:
% [base_width, half_width, half_Vm, fall_time, min_idx, min_val, 
%  max_ahp, ahp_decay_constant, dahp_mag, dahp_idx] = ...
%      calcWidthFall(s, max_idx, max_val, init_idx, init_val)
%
% Description:
%   max_* can be the peak_* from calcInitVm.
%
%   Parameters:
%	s: A spike_shape object.
%	max_idx: The index of the maximal point [dt].
%	max_val: The value of the maximal point [dy].
%	init_idx: The index of spike initiation point [dt].
%	init_val: The value of spike initiation point [dy].
%
%   Returns:
%	base_width: Width of spike at base [dt]
%	half_width: Width of spike at half_Vm [dt]
%	half_Vm: Half height of spike [dy]
%	fall_time: Time from peak to initialization level [dt].
%	min_idx: The index of the minimal point of the spike_shape [dt].
%	max_ahp: Magnitude from initiation to minimum [dy].
%	ahp_decay_constant: Approximation to refractory decay after maxAHP [dt].
%	dahp_mag: Magnitude of the double AHP peak
%	dahp_mag: Index of the double AHP peak
%
% See also: spike_shape
%
% $Id$
%
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2004/08/02
%   Based on @spike_trace/shapestats by Jeremy Edgerton.

%# constants
%#min_val = s.trace.data(min_idx);
%#max_val = s.trace.data(max_idx);

%# Find depolarized part (+/- 1mV tolerance)
depol = find(s.trace.data(floor(max_idx):end) <= (init_val + 1));

if isempty(depol) || floor((depol(1) + max_idx - 1)) == length(s.trace.data)
  warning('spike_shape:no_repolarize', 'Spike failed to repolarize.');
  base_width = NaN;
  half_width = NaN;
  half_Vm = NaN;
  fall_time = NaN;
  min_idx = NaN;
  min_val = NaN;
  max_ahp = NaN;
  ahp_decay_constant = NaN;
  dahp_mag = NaN;
  dahp_idx = NaN;
  return;
end

end_depol = depol(1) + max_idx - 1;

%# Interpolate to find the threshold crossing point
denum = (s.trace.data(floor(end_depol)) - s.trace.data(floor(end_depol) + 1));
if denum < -15
  extra_time = (s.trace.data(floor(end_depol)) - init_val - 1) / denum;
else 
  extra_time = 0;
end
fall_init_cross_time = end_depol + extra_time;

%# Base width and fall time
base_width = fall_init_cross_time - init_idx;
fall_time = fall_init_cross_time - max_idx;

%# Half width threshold
half_Vm = init_val + (max_val - init_val) / 2;

%# Find part above half Vm
start_from = max(floor(max_idx - 3*1e-3 / s.trace.dt), 1);
above_half = start_from - 1 + find(s.trace.data(start_from:end) >= half_Vm);

%# Find the first discontinuity to match only the first down ramp
some_of_the_above = above_half(above_half > floor(max_idx));
end_of_first_hump = find(diff(some_of_the_above) > 1);
if length(end_of_first_hump) > 0
  end_of_first_hump = end_of_first_hump(1) + floor(max_idx);
else
  end_of_first_hump = above_half(end);
end

%# Find the last discontinuity to match only the last up ramp
some_of_the_above = above_half(above_half < floor(max_idx + 1));
start_of_last_ramp = find(diff(some_of_the_above) > 1);
if length(start_of_last_ramp) > 0
  start_of_last_ramp = floor(max_idx) - (length(some_of_the_above) - ...
					 start_of_last_ramp(end));
else
  start_of_last_ramp = above_half(1);
end

half_start = start_of_last_ramp - ...
    (s.trace.data(start_of_last_ramp) - half_Vm) / ...
    (s.trace.data(start_of_last_ramp) - s.trace.data(start_of_last_ramp - 1));

half_end = end_of_first_hump + ...
    (s.trace.data(end_of_first_hump) - half_Vm) / ...
    (s.trace.data(end_of_first_hump) - ...
     s.trace.data(end_of_first_hump + 1));

half_width = half_end - half_start;

%# Now look for max AHP right after fall_time
[min_val, min_idx, max_ahp, dahp_mag, dahp_idx] = find_max_ahp(s, max_idx, fall_time, init_val);

%# Calculate AHP decay time constant approx: 
%# min_val - max_ahp * (1 - exp(-t/decay_constant))

%# Don't wrap to the beginning of the trace, already done at creation time
after_ahp = [s.trace.data(min_idx:end)];

%# Find double AHP is it exists
%#[dahp_mag, dahp_idx] = find_double_ahp(after_ahp, min_idx, s.trace.dt);

%# Threshold set at one time constant
%#decay_constant_threshold = min_val + max_ahp * (1 - exp(-1))

%# Try from resting potential
decay_constant_threshold = min_val + ...
    (s.trace.data(1) - min_val) * (1 - exp(-1));

%# If double ahp exists
if ~isnan(dahp_mag)
  after_dahp = s.trace.data(dahp_idx:end);
  %# Find minimum after the double AHP
  [af_min_val, af_min_idx] = min(after_dahp);
  recover_times = ...
      find(after_dahp(af_min_idx:end) >= decay_constant_threshold) + ...
      af_min_idx + dahp_idx;
else
  recover_times = find(after_ahp >= decay_constant_threshold) + min_idx;
end

if length(recover_times) > 0 
  %# Take first point for fitting exponential decay
  ahp_decay_constant = recover_times(1) - max_idx;
else 
  ahp_decay_constant = NaN;
end

function [dahp_mag, dahp_idx] = find_double_ahp(after_ahp, ahp_idx, dt)
  %# No dahp by default  
  dahp_mag = NaN;
  dahp_idx = NaN;

  %# Check for a maximum point right after the max AHP
  %# The first 30 ms, or until the end of trace
  duration=after_ahp(1:min(floor(30e-3 / dt), length(after_ahp))); 

  [max_val, max_idx] = max(duration);

  %# Check if maximum point exists
  if max_idx == length(duration)   
    return
  end

  %# Make linear approximation to an ahp bump
  dahp_bump_rise = duration(1) + (max_val - duration(1)) * (0:(max_idx-1)) / (max_idx-1);
  %#dahp_bump_rise = duration(1):(max_val - duration(1))/max_idx:max_val;
  fall_time = length(duration) - max_idx - 1;
  dahp_bump_fall = max_val + (duration(end) - max_val) * (0:fall_time) / fall_time;
  %#dahp_bump_fall = max_val:(duration(end) - max_val)/(length(duration) - max_idx):duration(end);
  dahp_bump = [dahp_bump_rise(1:end), dahp_bump_fall(1:end)]';

  %# Make linear approximation to no double ahp case
  no_dahp = [duration(1) + ...
    (1:length(duration))*(duration(end) - duration(1))/length(duration)]';

  %# Calculate error of hypothesis to reality
  dahp_error = sum(abs(dahp_bump - duration));
  nodahp_error = sum(abs(no_dahp - duration));

  if dahp_error <= nodahp_error
    dahp_idx = ahp_idx + max_idx;
    dahp_mag = max_val - duration(1);
  end

function [min_val, min_idx, max_ahp, dahp_mag, dahp_idx] = ...
      find_max_ahp(s, max_idx, fall_time, init_val)
  start_from = min(length(s.trace.data), ceil(max_idx + fall_time));
  windowsize = 6;
  if length(s.trace.data) - start_from + 1 > windowsize
    after_fall = medfilt1(s.trace.data((start_from-1):end), windowsize);
    after_fall = after_fall(2:end); %#  remove medfilt artifact from first sample
  else
    after_fall = s.trace.data(start_from:end);
  end

  thr_start_from =  1; %# floor(1e-3/s.trace.dt); %# plus some ms  
  first_thr_crossing = thr_start_from - 1 + find(after_fall(thr_start_from:end) <= (init_val + 1));
  if length(first_thr_crossing) == 0
    first_thr_crossing_idx = 1;
  else
    first_thr_crossing_idx = first_thr_crossing(1);
  end

  %# find next time potential rises to threshold value
  next_thr_crossing = find(after_fall(first_thr_crossing_idx:end) > (init_val + 1));
  
  if length(next_thr_crossing) == 0
    end_at = length(after_fall);
  else
    end_at = next_thr_crossing(1) + first_thr_crossing_idx - 1;
  end

  %# Max AHP must be the minimal point in between
  [min_val, min_fall_idx] = min(after_fall(1:end_at));

  min_idx = min_fall_idx + start_from - 1;

  max_ahp = max(0, init_val - min_val); 	%# maximal AHP amplitude
  
  [dahp_mag, dahp_idx] = find_double_ahp(after_fall(min_fall_idx:end_at), ...
					 min_fall_idx, s.trace.dt);

