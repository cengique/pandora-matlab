function b = set(a, attr, val)
% set - Generic method for setting object attributes.
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/08
try
  eval(['a.' attr ' = val;']);
  b = a;
catch
  errstr = lasterror;
  a.trace = set(a.trace, attr, val);
  b = a;
end
