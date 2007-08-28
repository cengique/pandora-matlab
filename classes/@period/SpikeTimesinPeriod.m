function SpkTimes = SpikeTimesinPeriod(period, times)

% Interval - Returns the spike times in a period. 
%
% Usage:
% SpkTimes=Interval(times, period)
%
% Description:
%
%   Parameters:
%	times: an array of spike times.
%   period: A period object
%
%   Returns:
%	the_period: The cropped set of spike times that fall within a period.
%
% See also: period, cip_trace, trace, spikes
%
% $Id$
%
% Author: Tom Sangrey, 2006/01/26

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

%get period boundaries and the number of spikes
time_begin = period.start_time
time_end = period.end_time
numSpikes = size(times,2);

%chop off the spike times before the period 
i=1;
while(times(i)<time_begin)
    i=i+1;
end
SpkTimes=times(i:1:numSpikes)

%chop off the spike times after the period
i=1;
while(SpkTimes(i)<time_end)
    i=i+1;
end
SpkTimes=SpkTimes(1:1:i-1)