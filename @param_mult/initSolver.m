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

props = mergeStructs(defaultValue('props', struct), get(a_pm, 'props'));

% call parent function [causes problems with fHandle]
% a_sol = initSolver(a_pm.param_func, a_sol);

% get name
name = getFieldDefault(props, 'name', get(a_pm, 'id'));

child_props = struct;

if isfield(props, 'initV')
  child_props.initV = props.initV;
end

% add this function first
if isfield(props, 'isIntable') && props.isIntable == 1
  %disp(['Adding intable ' name ])
  a_sol = add(a_sol, a_pm, struct('name', name));
  % initialize variable with given V value if given
  if isfield(props, 'initV')
    a_sol = ...
        initVal(a_sol, name, ...
                feval(getFieldDefault(props, 'init_val_func', @(a, x) x ), ...
                      a_pm.f, props.initV));
  end
end

% then add children
child_names = fieldnames(a_pm.f);
num_childs = length(child_names);
child_cells = struct2cell(a_pm.f)';

% call recursively for child functions
for f_num = 1:num_childs
  a_f = child_cells{f_num};
  %disp(['Adding ' child_names{f_num} ', (' class(a_f) ')'])
  a_sol = initSolver(a_f, a_sol, mergeStructs(struct('name', child_names{f_num}), ...
                                              child_props));
end
