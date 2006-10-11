function the_period = periodPulseIni50ms(t)

% periodPulseIni50ms - Returns the first 50ms of the CIP period of 
%			cip_trace, t. 
%
% Usage:
% the_period = periodPulseIni50ms(t)
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

the_period = period(t.pulse_time_start, t.pulse_time_start + ...
		    floor(50e-3 / t.trace.dt));
