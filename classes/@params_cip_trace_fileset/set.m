function a = set(a, attr, val)
% set - Generic method for setting object attributes.
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/08
try
  a.(attr) = val;
catch
  a.params_tests_fileset = set(a.params_tests_fileset, attr, val);
end
