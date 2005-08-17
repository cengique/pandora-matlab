function s = addSpike(s, times)

% addSpike - Adds to the list of spike times in the spikes object.
%
% Usage:
% s = addSpike(s, times)
%
% Description:
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
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/08/16

%# TODO: need to order times?
s.times = [s.times times];
