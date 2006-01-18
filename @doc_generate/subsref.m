function b = subsref(a,index)
% subsref - Defines generic indexing for objects.

%# If a is an array, use built-in methods
if length(a) > 1
  b = builtin('subsref', a, index);
  return;
end

if size(index, 2) > 1
  first = subsref(a, index(1));
  %# recursive
  b = subsref(first, index(2:end));
else
  switch index.type
    case '()'
      %# Delegate to base class
      error('indexing operator not defined.');
      %#b = a(index.subs{:});
    case '.'
      b = get(a, index.subs); 
    case '{}'
      b = a{index.subs{:}};
  end
end