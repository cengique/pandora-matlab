function s = display(t)

% Generic object display method.
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/04

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Handle differently if an array of DBs
if length(t) > 1
  disp(t);
  return;
end

disp(sprintf('%s, %s', class(t), get(t, 'id')));

page_names = fieldnames(t.page_idx);

if ~ isempty(page_names)
  disp('Page names:');
  disp(page_names);
end

display(t.tests_db);

%disp([ num2str(dbsize(t.tests_db, 3)) ' pages of the above matrix.']);


