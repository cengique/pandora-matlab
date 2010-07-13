function a_sol = setVals(a_sol, vals)

% setVals - Set values of all variables.
%
% Usage:
%   a_sol = setVals(a_sol, vals)
%
% Parameters:
%   a_sol: A param_func object.
%   vals: Values of variables.
%		
% Returns:
%   a_sol: Updated solver_int object.
%
% Description:
%   Called from ODE function at the end of each iteration to update
% variable values.
%
% Example:
%   >> a_sol = setVals(a_sol, [0 1 2])
%
% See also: dt, add, integrate, solver_int, deriv_func, param_func
%
% $Id: setVals.m 88 2010-04-08 17:41:24Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/06/10

% Copyright (c) 2009-2010 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

a_sol.vars = cell2struct(num2cell(vals(:)), fieldnames(a_sol.vars), 1);
