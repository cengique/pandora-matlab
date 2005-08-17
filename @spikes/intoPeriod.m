function obj = intoPeriod(s, a_period)

% intoPeriod - Shifts the spikes times to be within the given period.
%
% Usage:
% obj = intoPeriod(s, a_period)
%
% Description:
%   Assuming this spikes object's length fits into the given period, it shifts
% all times to start from the beginning of the given period. This may be used
% to reconstruct the original spikes object from subperiods that were cut out
% previously, using the withinPeriod method.
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
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/07/31
% Modified: (see CVS log)

%# TODO:
%# - Relate this method by overloading an abstract class/interface periodable(?) 

%# shift the offset
s.times = s.times + a_period.start_time - 1; 

if max(s.times) > a_period.end_time
  error('Spikes object does not fit into desired period.');
end

obj = s;

