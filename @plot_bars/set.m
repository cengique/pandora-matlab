function b = set(a, attr, val)
% set - Generic method for setting object attributes.
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/08
if ~ isa(a, 'plot_abstract')
  builtin('set', a, attr, val);
else
  try
    a.(attr) = val;
    b = a;
  catch
    errstr = lasterror;
    a.plot_stack = set(a.plot_stack, attr, val);
    b = a;
  end
end