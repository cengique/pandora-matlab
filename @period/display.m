function s = display(t)

% Generic object display method.
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/04

disp(sprintf('%s', class(t)));
struct(t)

