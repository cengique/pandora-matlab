function s = display(t)

% Generic object display method.
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/04

disp(sprintf('%s, %s', class(t), t.id));
struct(t)
disp('Database entries for: ');
disp(fieldnames(t.col_idx));

