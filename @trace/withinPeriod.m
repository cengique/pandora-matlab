function obj = withinPeriod(t, a_period)

% withinPeriod - Returns a trace object valid only within the given period.
%
% Usage:
% obj = withinPeriod(t, a_period)
%
% Description:
%
%   Parameters:
%	t: A trace object.
%	a_period: The desired period
%
%   Returns:
%	obj: A trace object
%
% See also: trace, period
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/25
% Modified:

%# TODO:
%# - Relate this method by overloading an abstract class/interface duration(?) 

t.data = t.data(a_period.start_time:a_period.end_time);

obj = t;

