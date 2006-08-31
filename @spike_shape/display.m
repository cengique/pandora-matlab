function s = display(t)

% Generic object display method.
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/04

num = size(t);
if max(num) > 1
  s = [ '[' sprintf('%dx', num(1:(end-1))) num2str(num(end)) ' ' class(t) ']' ];
  disp(s);
  struct(t(1))
else
  s = sprintf('%s', t.trace.id);
  disp(s);
  struct(t)
end

