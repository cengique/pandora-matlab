function b = set(a, attr, val)
% set - Generic method for setting object attributes.
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/08
try
  eval(['a.' attr ' = val;']);
  b = a;
catch
  a.tests_db = set(a.tests_db, attr, val);
  b = a;
end
