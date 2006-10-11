function a = set(a, attr, val)
% set - Generic method for setting object attributes.
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/02/06
try
  a.(attr) = val;
catch
  %# delegate to upper level
  a.script_array = set(a.script_array, attr, val);
end
