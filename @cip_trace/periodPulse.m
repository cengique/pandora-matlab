function _period = periodPulse(t)

% periodPulse - Returns the CIP period of cip_trace, t. 
%
% Usage:
% _period = periodPulse(t)
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

_period = period(t.pulse_time_start, t.pulse_time_start + t.pulse_time_width);
