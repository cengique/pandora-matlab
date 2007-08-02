function b = get(a, attr)
% get - Defines generic attribute retrieval for objects.
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/14
try
  b = a.(attr);
catch
  %# Then try the parent class
  b = get(a.script_array, attr);
end
