function s = display(t)

% Generic object display method.
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/04

disp(sprintf('%s, %s', class(t), get(t, 'id')));

page_names = fieldnames(t.page_idx);

if ~ isempty(page_names)
  disp('Page names:');
  disp(page_names);
end

disp(['Optional properties of ' class(t) ':']);
struct(t.props)

display(t.tests_db);

%#disp([ num2str(dbsize(t.tests_db, 3)) ' pages of the above matrix.']);


