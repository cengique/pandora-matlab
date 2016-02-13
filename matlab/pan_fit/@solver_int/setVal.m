function a_sol = setVal(a_sol, var_id, val)

% setVal - Set value of variable.
%
% Usage:
%   a_sol = setVal(a_sol, var_id, val)
%
% Parameters:
%   a_sol: A param_func object.
%   var_id: Id string of variable to set
%   val: Numeric value to set.
%		
% Returns:
%   a_sol: Updated.
%
% Description:
%
% Example:
%   >> a_sol = setVal(a_sol, 'm', 1)
%
% See also: dt, add, setVals, integrate, solver_int, deriv_func, param_func
%
% $Id: setVal.m 88 2010-04-08 17:41:24Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/08/07

% Copyright (c) 2009-2011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

a_sol.vars.(var_id) = val;
