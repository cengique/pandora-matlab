function a_sol = initVal(a_sol, var_id, val)

% initVal - Set initial value of variable.
%
% Usage:
%   a_sol = initVal(a_sol, var_id, val)
%
% Parameters:
%   a_sol: A param_func object.
%   var_id: Id string of variable to set
%   val: Initial value of variable. 
%
% Returns:
%   a_sol: Updated solver_int object.
%
% Description:
%
% Example:
%   >> a_sol = initVal(a_sol, 'm', 0)
%
% See also: dt, add, integrate, solver_int, deriv_func, param_func
%
% $Id: initVal.m 88 2010-04-08 17:41:24Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/06/10

% Copyright (c) 2009-2010 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

a_sol.vars.(var_id) = val;
