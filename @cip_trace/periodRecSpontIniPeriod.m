function the_period = periodRecSpontIniPeriod(t, IniPeriod)

% periodRecSpont - Returns the recovery spontaneous activity period 
%		of cip_trace, t. 
%
% Usage:
% the_period = periodRecSpont(t)
%
% Description:
%   Parameters:
%	t: A trace object.
%   iniPeriod: the time following pulse offset that is to be ignored
%
%   Returns:
%	the_period: A period object.
%
% See also: period, cip_trace, trace
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>,Tom Sangrey 2004/08/25

time_start = t.pulse_time_start + t.pulse_time_width;
time_end = length(t.trace.data);

the_period = period(time_start +IniPeriod, time_end);
