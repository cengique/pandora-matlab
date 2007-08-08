function whole_period = periodWhole(t)

% periodWhole - Returns the boundaries of the whole period of trace, t. 
%
% Usage:
% whole_period = periodWhole(t)
%
% Description:
%
%   Parameters:
%	t: A trace object.
%
% See also: period, trace
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/07/30

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

whole_period = period(1, length(t.data));
