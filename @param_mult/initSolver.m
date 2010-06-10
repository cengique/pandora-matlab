function a_sol = initSolver(a_pm, a_sol, props)

% initSolver - Recursively adds all integratable functions to the solver.
%
% Usage:
%   a_sol = initSolver(a_pm, a_sol, props)
%
% Parameters:
%   a_pm: A param_mult object.
%   a_sol: A solver_int object.
%   props: A structure with any optional properties.
%     (passed to param_func/initSolver)
%		
% Returns:
%   a_sol: Updated solver. 
%
% Description:
%
% Example:
%   >> a_sol = initSolver(a_pf, a_sol)
%
% See also: param_func, param_mult
%
% $Id: initSolver.m 88 2010-04-08 17:41:24Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/06/10

% Copyright (c) 2009 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

% call parent function
a_sol = initSolver(a_pm.param_func, a_sol);

% call recursively for child functions
for a_f = struct2cell(a_pm.f)'
  a_sol = initSolver(a_f{1}, a_sol);
end
