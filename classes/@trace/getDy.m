function dy = getDy(t)

% getDy - Returns dy.
%
% Usage:
% dy = getDy(t)
%
% Description:
%
%   Parameters:
%	t: A trace object.
%
%   Returns:
%	dy: The dy value.
%
% See also: trace
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/31

if nargin == 0 %# Called with no params
  error('Need trace parameter.');
end

dy = t.dy;

