function a = subsasgn(a, index, val)
% subsasgn - Defines generic index-based assignment for objects.
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/02/06
if size(index, 2) > 1
  %# recursive
  a = subsasgn(a, index(1), subsasgn(subsref(a, index(1)), index(2:end), val));
else
  switch index.type
    case '()'
      a(index.subs{:}) = val;
    case '.'
      a = set(a, index.subs, val);
    case '{}'
      a{index.subs{:}} = val;
  end
end
