function whole_period = periodWhole(s)

% periodWhole - Returns the boundaries of the whole period of spikes, s. 
%
% Usage:
% whole_period = periodWhole(s)
%
% Description:
%   Parameters:
%	s: A spikes object.
%
% See also: period, spikes
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/07/30

whole_period = period(1, s.num_samples);
