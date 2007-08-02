function b = get(a, attr)
% get - Defines generic attribute retrieval for objects.
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/14
try
  b = a.(attr);
catch
  errstr = lasterror;

  %# Then try the parent class
  b = get(a.dataset_db_bundle, attr);
end
