function b = subsref(a,index)
% subsref - Defines generic indexing for objects.
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/04
if size(index, 2) > 1
  first = subsref(a, index(1));
  %# recursive
  b = subsref(first, index(2:end));
else
  switch index.type
    case '()'
      b = a(index.subs{:});
    case '.'
      b = get(a, index.subs); 
    case '{}'
      b = a{index.subs{:}};
  end
end