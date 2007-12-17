function a = subsasgn(a, index, val)
% subsasgn - Defines generic index-based assignment for objects.
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/02/06

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% If a is an array, use built-in methods
num = length(a);
if num == 0
  a = builtin('subsasgn', val, index, val);
  return;
elseif length(a) > 1
  a = builtin('subsasgn', a, index, val);
  return;
end

if size(index, 2) > 1
  % recursive if multiple indices
  a = subsasgn(a, index(1), subsasgn(subsref(a, index(1)), index(2:end), val));
else
  switch index.type
    case '()'
      a = builtin('subsasgn', a, index, val);
      return;
    case '.'
      a = set(a, index.subs, val);
    case '{}'
      error(['Operator {} not defined for ' class(a) '.']);
  end
end
