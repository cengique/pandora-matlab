function a_sol = add(a_sol, a_deriv_func, props)

% add - Add a deriv_func variable to solver_int.
%
% Usage:
%   a_sol = add(a_sol, a_deriv_func, props)
%
% Parameters:
%   a_sol: A param_func object.
%   a_deriv_func: deriv_func objects to be integrated.
%   props: A structure with any optional properties.
%     name: Use this name to register the function in the solver.
%		
% Returns:
%   a_sol: Updated solver_int object.
%
% Description:
%
% Example:
%   >> a_sol = add(a_sol, deriv_func(@(fs, s, x) (fs.inf(x) - dt(s, 'm') - dt(s, 'm')) / 10, 'm'))
%
% See also: dt, integrate, solver_int, deriv_func, param_func
%
% $Id: add.m 88 2010-04-08 17:41:24Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/06/10

% Copyright (c) 2009-2010 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

name = getFieldDefault(props, 'name', get(a_deriv_func, 'id'));

a_sol.vars.(name) = 0;
a_sol.dfdtHs.(name) = fHandle(a_deriv_func);
