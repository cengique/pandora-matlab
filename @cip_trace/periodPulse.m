function the_period = periodPulse(t)

% periodPulse - Returns the CIP period of cip_trace, t. 
%
% Usage:
% the_period = periodPulse(t)
%
% Description:
%
%   Parameters:
%	t: A trace object.
%
%   Returns:
%	the_period: A period object.
%
% See also: period, cip_trace, trace
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/25

the_period = period(t.pulse_time_start, t.pulse_time_start + t.pulse_time_width - 1);
