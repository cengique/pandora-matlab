function [base_width, half_width, half_Vm, fall_time] = ...
      calcWidthFall(s, max_idx, max_val, min_idx, init_idx)

% calcWidthFall - Calculates the spike width and fall information of the 
%		spike_shape, s. 
%
% Usage:
% [init_val, init_idx, rise_time, amplitude, max_ahp] = 
%	calcWidthFall(s, max_idx, min_idx)
%
% Description:
%   max_* can be the peak_* from calcInitVm.
%
%   Parameters:
%	s: A spike_shape object.
%	max_idx: The index of the maximal point [dt].
%	max_val: The value of the maximal point [dt].
%	min_idx: The index of the minimal point [dt].
%	init_idx: The index of spike initiation point [dt].
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
init_val = s.trace.data(init_idx);
min_val = s.trace.data(min_idx);
%#max_val = s.trace.data(max_idx);

%# Find depolarized part
depol = find(s.trace.data >= init_val);

if depol(end) == length(s.trace.data)
error('Spike failed to repolarize.');
end

end_depol = depol(end);

%# Interpolate to find the threshold crossing point
extra_time = (s.trace.data(end_depol) - init_val) / ...
             (s.trace.data(end_depol) - s.trace.data(end_depol + 1)); 
fall_init_cross_time = end_depol + extra_time;

%# Base width and fall time
base_width = fall_init_cross_time - init_idx;
fall_time = fall_init_cross_time - max_idx;

%# Half width threshold
half_Vm = init_val + (max_val - init_val) / 2;

%# Find part above half Vm
above_half = find(s.trace.data >= half_Vm);

half_start = above_half(1) - ...
    (s.trace.data(above_half(1)) - half_Vm) / ...
    (s.trace.data(above_half(1)) - s.trace.data(above_half(1) - 1));

half_end = above_half(end) + ...
    (s.trace.data(above_half(end)) - half_Vm) / ...
    (s.trace.data(above_half(end)) - s.trace.data(above_half(end) + 1));

half_width = half_end - half_start;
