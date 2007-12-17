function s = display(t)

% Generic object display method.
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/04

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Handle differently if an array of objects
if length(t) > 1
  disp(t);
  return;
end

disp(sprintf('%s, %s', class(t), get(get(t, 'joined_db'), 'id')));
%disp(t);
struct(t)

disp(['Optional properties of ' class(t) ':']);
struct(t.props)
