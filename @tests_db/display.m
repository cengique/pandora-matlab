function s = display(t)

% Generic object display method.
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/04

disp(sprintf('%s, %s', class(t), t.id));
%#struct(t) not needed
disp([ num2str(size(t.data, 1)) ' rows in database with ' ...
      num2str(size(t.data, 2)) ' columns, and ' ...
      num2str(size(t.data, 3)) ' pages.']);
disp('Column names:');
disp(fieldnames(t.col_idx));
row_names = fieldnames(t.row_idx);
if ~ isempty(row_names)
  disp('Row names:');
  disp(row_names);
end
disp(['Optional properties of ' class(t) ':']);
struct(t.props)
