function a = set(a, attr, val)
% set - Generic method for setting object attributes.
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/08

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.
try
  a.(attr) = val;
catch
  if find(ismember(getColNames(a.tests_db), attr))
    % TODO: stop using tests_db!
    a.tests_db = assignRowsTests(a.tests_db, val, 1, attr);
  else
    a.tests_db = set(a.tests_db, attr, val);
  end
end
