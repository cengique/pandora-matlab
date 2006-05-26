function s = display(t)

% Generic object display method.
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/04

s = sprintf('%s, %s', class(t), get(t, 'title'));
disp(s);
%#disp(t);
struct(t)

disp(t.plot_abstract);