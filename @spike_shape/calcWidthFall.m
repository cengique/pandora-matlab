function [base_width, half_width, half_Vm, fall_time] = ...
      calcWidthFall(s, max_idx, max_val, min_idx, init_idx, init_val)

% calcWidthFall - Calculates the spike width and fall information of the 
%		spike_shape, s. 
%
% Usage:
% [base_width, half_width, half_Vm, fall_time] = ...
%      calcWidthFall(s, max_idx, max_val, min_idx, init_idx)
%
% Description:
%   max_* can be the peak_* from calcInitVm.
%
%   Parameters:
%	s: A spike_shape object.
%	max_idx: The index of the maximal point [dt].
%	max_val: The value of the maximal point [dy].
%	min_idx: The index of the minimal point [dy].
%	init_idx: The index of spike initiation point [dt].
%	init_val: The value of spike initiation point [dy].
%
%   Returns:
%	base_width: Width of spike at base [dt]
%	half_width: Width of spike at half_Vm [dt]
%	half_Vm: Half height of spike [dy]
%	fall_time: Time from peak to initialization level [dt].
%
% See also: spike_shape
%
% $Id$
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2004/08/02
%   Based on @spike_trace/shapestats by Jeremy Edgerton.

%# constants
%#init_val = s.trace.data(init_idx);
min_val = s.trace.data(min_idx);
%#max_val = s.trace.data(max_idx);

%# Find depolarized part (+/- 1mV tolerance)
depol = find(s.trace.data(floor(max_idx):end) <= (init_val + 1));

if isempty(depol) || floor((depol(1) + max_idx - 1)) == length(s.trace.data)
  warning('spike_shape:no_repolarize', 'Spike failed to repolarize.');
  base_width = NaN;
  half_width = NaN;
  half_Vm = NaN;
  fall_time = NaN;
  return;
end

end_depol = depol(1) + max_idx - 1;

%# Interpolate to find the threshold crossing point
extra_time = (s.trace.data(floor(end_depol)) - init_val) / ...
             (s.trace.data(floor(end_depol)) - ...
	      s.trace.data(floor(end_depol) + 1)); 
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

half_start = above_half(1) - ...
    (s.trace.data(above_half(1)) - half_Vm) / ...
    (s.trace.data(above_half(1)) - s.trace.data(above_half(1) - 1));

half_end = end_of_first_hump + ...
    (s.trace.data(end_of_first_hump) - half_Vm) / ...
    (s.trace.data(end_of_first_hump) - ...
     s.trace.data(end_of_first_hump + 1));

half_width = half_end - half_start;
