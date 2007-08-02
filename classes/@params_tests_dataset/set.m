function a = set(a, attr, val)
% set - Generic method for setting object attributes.
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/08

%#try
  a.(attr) = val;
%#catch
  %#rethrow(lasterror);
%#end
