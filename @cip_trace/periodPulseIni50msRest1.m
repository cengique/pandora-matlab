function _period = periodPulseIni50msRest1(t)

% periodPulseIni50msRest1 - Returns the first half of the rest after the 
%			first 50ms of the CIP period of cip_trace, t. 
%
% Usage:
% _period = periodPulseIni50msRest1(t)
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

time_start = t.pulse_time_start + 50e-3 / t.dt + 1;
time_end = t.pulse_time_start + t.pulse_time_width;

_period = period(time_start, time_start + (time_end - time_start) / 2);
