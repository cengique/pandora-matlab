function a = set(a, attr, val)
% set - Generic method for setting object attributes.
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/08
try
  eval(['a.' attr ' = val;']);
catch
  a.params_tests_dataset = set(a.params_tests_dataset, attr, val);
end
