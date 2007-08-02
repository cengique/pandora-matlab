function b = set(a, attr, val)
% set - Generic method for setting object attributes.
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/08

num = length(a);
if num > 1
  %# If a vector, loop and do for all
  for i=1:num
    set(a(i), attr, val);
  end
else
  try
    eval(['a.' attr ' = val;']);
    b = a;
  catch
    %# delegate to upper level
    b = a;
    b.trace = set(a.trace, attr, val);
  end
end
