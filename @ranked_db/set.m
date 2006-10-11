function a = set(a, attr, val)
% set - Generic method for setting object attributes.
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/08
try
  a.(attr) = val;
catch
  a.tests_db = set(a.tests_db, attr, val);
end
