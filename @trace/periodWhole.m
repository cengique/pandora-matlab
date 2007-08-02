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

whole_period = period(1, length(t.data));
