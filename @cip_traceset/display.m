function s = display(t)

% Generic object display method.
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/04

if length(t) > 1
  if iscell(t)
    first = t{1};
  else
    first = t(1);
  end
  disp(sprintf('%dx%d %s', size(t, 1), size(t, 2), class(first)))
  return
end

disp(sprintf('%s, %s', class(t), get(t, 'id')));
struct(t)

disp(['Optional properties of ' class(t) ':']);
struct(t.props)

display(t.params_tests_dataset);

