function s = addSpike(s, times)

% addSpike - Adds to the list of spike times in the spikes object.
%
% Usage:
% s = addSpike(s, times)
%
% Description:
%
%   Parameters:
%	s: A spikes object.
%	times: Times of spikes to add
%
%   Returns:
%	s: The updated object.
%
% See also: spikes
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/08/16

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

%# TODO: need to order times?
s.times = [s.times times];
