function _period = periodRecSpont2(t)

% periodRecSpont2 - Returns the second half of the recovery spontaneous
%		 activity period of cip_trace, t. 
%
% Usage:
% _period = periodRecSpont2(t)
%
% Description:
%   Parameters:
%	t: A trace object.
%
%   Returns:
%	_period: A period object.
%
% See also: period, cip_trace, trace
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/25

time_start = t.pulse_time_start + t.pulse_time_width + 1;
time_end = length(t.trace.data);

_period = period(time_start + (time_end - time_start) / 2 + 1, time_end);
