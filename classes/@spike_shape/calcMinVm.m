function [min_val, min_idx, max_min_time] = calcMinVm(s, max_idx)

% calcMinVm - Calculates the minimal value of the spike_shape, s. 
%
% Usage:
% [min_val, min_idx, max_min_time] = calcMinVm(s, max_idx)
%
% Description:
%
%   Parameters:
%	s: A spike_shape object.
%	max_idx: The index of the maximal point of the spike_shape [dt].
%
%   Returns:
%	min_val: The min value [dy].
%	min_idx: Its index in the spike_shape [dt].
%	max_min_time: Time from max to min [dt].
%
% See also: period, spike_shape, trace/calcMin
%
% $Id$
%
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2004/08/02
%   Based on @spike_trace/shapestats by Jeremy Edgerton.

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

[min_val, min_idx] = calcMin(s.trace, period(max_idx, length(s.trace.data)));
min_idx = min_idx + max_idx - 1;
max_min_time = min_idx - max_idx;

if max_min_time < 0
  error('Minimum voltage precedes peak!');
end
