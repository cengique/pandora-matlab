function val = getVal(a_sol, var_id)

% getVal - Get value of variable.
%
% Usage:
%   val = getVal(a_sol, var_id)
%
% Parameters:
%   a_sol: A param_func object.
%   var_id: Id string of variable to set
%		
% Returns:
%   val: Value of variable.
%
% Description:
%
% Example:
%   >> val = getVal(a_sol, 'm')
%
% See also: dt, add, setVals, integrate, solver_int, deriv_func, param_func
%
% $Id: getVal.m 88 2010-04-08 17:41:24Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/06/10

% Copyright (c) 2009-2010 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

val = a_sol.vars.(var_id);
