function [max_val, max_idx] = calcMaxVm(s)

% calcMaxVm - Calculates the maximal value of the spike_shape, s. 
%
% Usage:
% [max_val, max_idx] = calcMaxVm(s)
%
% Description:
%
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
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/02

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

%# Look for the peak only in the first 10 ms or so.
or_so = floor(min(12e-3 / s.trace.dt, length(s.trace.data)));
[max_val, max_idx] = calcMax(s.trace, period(1, or_so));

