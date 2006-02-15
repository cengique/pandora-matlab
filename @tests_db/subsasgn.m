function a = subsasgn(a, index, val)
% subsasgn - Defines generic index-based assignment for objects.
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/02/06

%# If a is an array, use built-in methods
num = length(a);
if num == 0
  a = builtin('subsasgn', val, index, val);
  return;
elseif length(a) > 1
  a = builtin('subsasgn', a, index, val);
  return;
end

if size(index, 2) > 1
  %# recursive if multiple indices
  a = subsasgn(a, index(1), subsasgn(subsref(a, index(1)), index(2:end), val));
else
  switch index.type
    case '()'
      a = assignRowsTests(a, val, index.subs{:});
    case '.'
      a = set(a, index.subs, val);
    case '{}'
      error('{} not defined for tests_db.');
  end
end
