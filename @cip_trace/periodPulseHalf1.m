function the_period = periodPulseHalf1(t)

% periodPulseHalf1 - Returns the first half of the CIP period of cip_trace, t. 
%
% Usage:
% the_period = periodPulseHalf1(t)
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

time_start = t.pulse_time_start;
time_end = t.pulse_time_start + t.pulse_time_width - 1;

the_period = period(time_start, time_start + t.pulse_time_width / 2 - 1);
