function res = integrate(a_sol, x, props)

% integrate - Set values of all variable.
%
% Usage:
%   res = integrate(a_sol, x, props)
%
% Parameters:
%   a_sol: A param_func object.
%   props: A structure with any optional properties.
%     time: Array of time points where functions should be integrated
%           (default=for all points in x)
%		
% Returns:
%   res: A structure array with the array of variable solutions.
%
% Description:
%
% Example:
%   >> res = integrate(a_sol)
%
% See also: dt, add, setVals, solver_int, deriv_func, param_func
%
% $Id: integrate.m 88 2010-04-08 17:41:24Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/06/10

% Copyright (c) 2009-2010 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

props = defaultValue('props', struct);

num_vars = length(fieldnames(a_sol.vars));
dfdt_init = repmat(NaN, num_vars, 1);
dfdtHs = struct2cell(a_sol.dfdtHs);

% by default integrate for all values in x
time = getFieldDefault(props, 'time', (0:(size(x, 1) - 1))*a_sol.dt);
size(time)
cell2mat(struct2cell(a_sol.vars)')

[t_tmp, res] = ...
    ode15s(@(t,vars) deriv_all(t, vars), ...
           time, cell2mat(struct2cell(a_sol.vars)'));

function dfdt = deriv_all(t, vars)
  a_sol = setVals(a_sol, vars);
  dfdt = dfdt_init;
  for var_num = 1:num_vars
    dfdt(var_num) = ...
        feval(dfdtHs{var_num}, ...
              struct('s', a_sol, 'v', x, 'dt', a_sol.dt));
  end
  end

end