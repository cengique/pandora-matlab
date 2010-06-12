function a_sol = solver_int(deriv_funcs, dt, id, props)
  
% solver_int - Solver for integrating a system of differential equations, dy/dt = A*x+b.
%
% Usage:
%   a_sol = solver_int(deriv_funcs, dt, id, props)
%
% Parameters:
%   deriv_funcs: deriv_func objects to be integrated.
%   dt: Time step [s].
%   id: An identifying string for this function.
%   props: A structure with any optional properties.
%		
% Returns a structure object with the following fields:
%   vars: A structure with each var name pointing to its current value.
%   dfdtHs: A structure with each var name pointing to its derivative function handle.
%   dt, id.
%
% Description:  
%   Deriv_Func objects can access the solver to read other variables
% during integration.
%
% General operations on solver_int objects:
%   solver_int		- Construct a new solver_int object.
%   integrate		- Integrate system of equations.
%   add			- Add a deriv_func variable.
%   dt			- Calculate the derivative of a variable.
%
% Additional methods:
%   See methods('solver_int')
%
% Example:
%   % solver with two system variables; m, h
%   a_sol = ...
%      solver_int(...
%        {deriv_func(@(fs, s, x) (fs.inf(x) - dt(s, 'm') - dt(s, 'm')) / 10, 'm'), ...
%	  deriv_func(@(fs, s, x) fs.inf(x) / 5, 'h')}, ...
%        'system of two eqs');
%   initVal(a_sol, 'm', 0); initVal(a_sol, 'h', 1);
%   r = integrate(a_sol)
%
% See also: deriv_func, param_func
%
% $Id: solver_int.m 128 2010-06-07 21:36:08Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/06/10

% TODO: 

  if nargin == 0 % Called with no params
    a_sol = struct;
    a_sol.vars = struct;
    a_sol.dfdtHs = struct;
    a_sol.dt = '';
    a_sol.id = '';
    a_sol = class(a_sol, 'solver_int');
  elseif isa(deriv_funcs, 'solver_int') % copy constructor?
    a_sol = deriv_funcs;
  else
    if ~ exist('props', 'var')
      props = struct;
    end
    
    num_vars = length(deriv_funcs);
    
    a_sol = struct;
    a_sol.vars = struct;
    a_sol.dfdtHs = struct;
    
    % TODO: loop over variables and add them
    for var_num = 1:num_vars
      var_id = get(deriv_funcs{var_num}, 'id');
      a_sol.vars.(var_id) = 0;
      a_sol.dfdtHs.(var_id) = fHandle(deriv_funcs{var_num});
    end
    
    a_sol.dt = dt;
    a_sol.id = id;
    a_sol = class(a_sol, 'solver_int');
  end
