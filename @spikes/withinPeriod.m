function obj = withinPeriod(s, period)

% withinPeriod - Returns a spikes object valid only within the given period.
%
% Usage:
% obj = withinPeriod(s, trace_index, times, period)
%
% Description:
%   Parameters:
%	s: A spikes object.
%	period: The period where spikes were found (optional)
%
%   Returns:
%	obj: Inter-spike-interval vector [dt]
%
% See also: trace, spikes, period
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/07/31
% Modified:

%# TODO:
%# - Relate this method by overloading an abstract class/interface periodable(?) 

s.times = s.times(s.times >= period.start_time & s.times <= period.end_time);
s.num_samples = period.end_time - period.start_time;

obj = s;

