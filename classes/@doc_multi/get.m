function b = get(a, attr)
% get - Defines generic attribute retrieval for objects.
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/14

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% If input is an array, then also return array
num_items = length(a);
if num_items > 1 
  % Create array of outputs
  for item_num = 1:num_items
    b(item_num) = get(a(item_num), attr);
  end
  return;
end

try
  b = getfield(struct(a), attr);
catch
  errstr = lasterror;

  % Then try the parent class
  b = get(a.doc_generate, attr);
end
