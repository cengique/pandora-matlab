function s = display(t)

% Generic object display method.
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/04

display(t.tests_db);

disp([ num2str(size(t.tests_db.data, 3)) ' pages of the above matrix.']);


