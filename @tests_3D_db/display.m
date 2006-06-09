function s = display(t)

% Generic object display method.
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/04

%# Handle differently if an array of DBs
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

%#disp([ num2str(dbsize(t.tests_db, 3)) ' pages of the above matrix.']);


