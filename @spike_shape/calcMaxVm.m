function [max_val, max_idx] = calcMaxVm(s)

% calcMaxVm - Calculates the maximal value of the spike_shape, s. 
%
% Usage:
% [max_val, max_idx] = calcMaxVm(s)
%
% Description:
%   Parameters:
%	s: A spike_shape object.
%
%   Returns:
%	max_val: The max value.
%	max_idx: Its index in the spike_shape [dt].
%
% See also: period, spike_shape, trace/calcMax
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/02

%# Look for the peak only in the first 10 ms or so.
[max_val, max_idx] = calcMax(s.trace, period(1, floor(10e-3 / s.trace.dt)));

