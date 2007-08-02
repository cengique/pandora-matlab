function obj = withinPeriod(s, a_period)

% withinPeriod - Returns a spikes object valid only within the given period, subtracts the offset.
%
% Usage:
% obj = withinPeriod(s, a_period)
%
% Description:
%
%   Parameters:
%	s: A spikes object.
%	a_period: The desired period 
%
%   Returns:
%	obj: A spikes object
%
% See also: spikes, period
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/07/31
% Modified:

%# TODO:
%# - Relate this method by overloading an abstract class/interface periodable(?) 

s = withinPeriodWOffset(s, a_period);

%# reset the offset
s.times = s.times - a_period.start_time + 1; 

obj = s;

