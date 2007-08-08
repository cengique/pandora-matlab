function the_period = periodPulseIni50msRest2(t)

% periodPulseIni50msRest2 - Returns the second half of the rest after the 
%			first 50ms of the CIP period of cip_trace, t. 
%
% Usage:
% the_period = periodPulseIni50msRest2(t)
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

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

time_start = t.pulse_time_start + 100e-3 / t.trace.dt + 1;
time_end = t.pulse_time_start + t.pulse_time_width - 1;

the_period = period(time_start + floor((time_end - time_start) / 2) + 1, ...
		    time_end);
