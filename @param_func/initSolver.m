function a_sol = initSolver(a_pf, a_sol, props)

% initSolver - If integratable, adds this function to the solver.
%
% Usage:
%   a_sol = initSolver(a_pf, a_sol, props)
%
% Parameters:
%   a_pf: A param_func object.
%   a_sol: A solver_int object.
%   props: A structure with any optional properties.
%     name: Use this name to register the function in the solver.
%
% Returns:
%   a_sol: Updated solver. 
%
% Description:
%   Will add the object a_pf to the solver a_sol only if a_pf's
% props.isIntable is 1.
%
% Example:
%   >> a_sol = initSolver(a_pf, a_sol)
%
% See also: param_func, setParam
%
% $Id: initSolver.m 88 2010-04-08 17:41:24Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/04/13

% Copyright (c) 2009-2010 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

props = mergeStructs(defaultValue('props', struct), get(a_pf, 'props'));

name = getFieldDefault(props, 'name', get(a_pf, 'id'));

if isfield(props, 'isIntable') && props.isIntable == 1
  %disp(['Adding intable ' name ])
  a_sol = add(a_sol, a_pf, struct('name', name));
  if isfield(props, 'initV')
    a_sol = ...
        initVal(a_sol, name, ...
                feval(getFieldDefault(props, 'init_val_func', @(a, x) x ), ...
                      struct, props.initV));
  end
end

