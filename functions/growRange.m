function range = growRange(ranges)

% growRange - Returns the maximal range from rows of axis limits. 
%
% Usage:
% range = growRange(ranges)
%
% Description:
%
%   Parameters:
% 	ranges: A matrix where each row is return val of axis func.
%		
%   Returns:
%	range: The maximal range obtained that includes all given axes.
%
% See also: 
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/13

mins = min(ranges, [], 1);
maxs = max(ranges, [], 1);

if (mins(1) - maxs(2)) == 0
  maxs(2) = maxs(2) + 1e-6;
end

if (mins(3) - maxs(4)) == 0
  maxs(4) = maxs(4) + 1e-6;
end

range = [mins(1) maxs(2) mins(3) maxs(4)];
