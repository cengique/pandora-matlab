function a = set(a, attr, val)
% set - Generic method for setting object attributes.
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/08
try
  a.(attr) = val;
catch
  a.doc_generate = set(a.doc_generate, attr, val);
end
