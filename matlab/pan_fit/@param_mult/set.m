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
  % set only existing sub functions
  if isfield(a.f, attr) 
    if isa(val, 'param_func')
      a.f.(attr) = val;
    else
      error('Can only set param_func objects as sub functions.');
    end
  else
    a.param_func = set(a.param_func, attr, val);
  end
end
