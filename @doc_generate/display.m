function s = display(t)

% Generic object display method.
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/04

%# Handle differently if an array of objects
if length(t) > 1
  disp(t);
  return;
end

disp(sprintf('%s, %s', class(t), get(t, 'id')));
%#disp(t);
struct(t)

disp(['Optional properties of ' class(t) ':']);
struct(t.props)
