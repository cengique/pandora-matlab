function whole_period = periodWhole(s)

% periodWhole - Returns the boundaries of the whole period of spikes, s. 
%
% Usage:
% whole_period = periodWhole(s)
%
% Description:
%
%   Parameters:
%	s: A spikes object.
%
% See also: period, spikes
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/07/30

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

whole_period = period(1, s.num_samples);
