function avg_t = runAvg(t)

% runAvg - Returns a trace which is the running average of this trace.
%
% Usage:
% avg_t = runAvg(t)
%
% Description:
%
%   Parameters:
%	t: A trace object.
%
%   Returns:
%	avg_t: A trace object that contains the running average of this trace.
%
% See also: trace
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2008/05/14

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

dt = get(t, 'dt');
data = get(t, 'data');
avg_t = set(t, 'data', cumsum(data) ./ (1:length(data))' * dt);
avg_t = set(avg_t, 'id', [ 'Running average of ' get(avg_t, 'id') ]);