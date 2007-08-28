function obj = withinPeriodWOffset(s, a_period)

% withinPeriodWOffset - Returns a spikes object valid only within the given period, keeps the offset.
%
% Usage:
% obj = withinPeriodWOffset(s, a_period)
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
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/05/09

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

s.times = s.times(s.times > a_period.start_time & s.times <= a_period.end_time);
s.num_samples = a_period.end_time - a_period.start_time;

obj = s;

