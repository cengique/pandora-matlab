function b = set(a, attr, val)
% set - Generic method for setting object attributes.
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/08

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

num = length(a);
if num > 1
  % If a vector, loop and do for all
  for i=1:num
    set(a(i), attr, val);
  end
else
  try
    eval(['a.' attr ' = val;']);
    b = a;
  catch
    % delegate to upper level
    b = a;
    b.trace = set(a.trace, attr, val);
  end
end
