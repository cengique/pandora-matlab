function the_period = periodRecSpontRestPeriod(t, IniPeriod)

% periodRecSpont - Returns the recovery spontaneous activity period 
%		of cip_trace, t. 
%
% Usage:
% the_period = periodRecSpont(t)
%
% Description:
%   Parameters:
%	t: A trace object.
%   iniPeriod: the time following pulse offset that is ignored. The rest of
%   the time is kept
%
%   Returns:
%	the_period: A period object.
%
% See also: period, cip_trace, trace
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>,Tom Sangrey 2006/01/26

time_start = t.pulse_time_start + t.pulse_time_width;
time_end = length(t.trace.data);

the_period = period(time_start +IniPeriod, time_end);
