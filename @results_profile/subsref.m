function b = subsref(a,index)
% subsref - Defines generic indexing for objects.
if size(index, 2) > 1
  first = subsref(a, index(1));
  %# recursive
  b = subsref(first, index(2:end));
else
  switch index.type
    case '()'
      %# Delegate to base class
      b = a(index.subs{:});
    case '.'
      %# Generalized get method, only need to define proper get methods
      %# in subclasses.
      b = get(a, index.subs);	
      %# eval(['a.' index.subs]);
    case '{}'
      b = a{index.subs{:}};
  end
end
