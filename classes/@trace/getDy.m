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

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 % Called with no params
  error('Need trace parameter.');
end

dy = t.dy;

