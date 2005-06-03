function s = display(t)

% Generic object display method.
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/04

%# Handle differently if an array of DBs
if length(t) > 1
  disp(t);
  return;
end

disp(sprintf('%s, %s', class(t), get(t, 'id')));

struct(t)

display(t.tests_db);

