function a_ps = param_tau_v(param_init_vals, id, props)
  
% param_tau_v - Parameterized time constant [ms] function, y = a + b/(1+exp((x+c)/d)).
%
% Usage:
%   a_ps = param_tau_v(param_init_vals, id, props)
%
% Parameters:
%   param_init_vals: Initial values of function parameters, p = [a b c d] in [ms].
%   id: An identifying string for this function.
%   props: A structure with any optional properties.
% 	   (Rest passed to param_func)
%		
% Returns a structure object with the following fields:
%	param_func.
%
% Description:
%   Specialized version (subclass) of param_func for time constant
%   voltage-dependence curves.
%
% Additional methods:
%	See methods('param_tau_v')
%
% See also: param_func, param_act, param_act_t, tests_db, plot_abstract
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2009/06/02

% TODO: doesn't need to be a class
  var_names = {'voltage [mV]', 'time constant [ms]'};
  param_names = {'a', 'b', 'V_half', 'k'};
  func_handle = @(p,x) p.a + p.b./(1 + exp((x+p.V_half) ./ p.k));

  props = defaultValue('props', struct);
  id = defaultValue('id', '');

  props = mergeStructs(props, ...
                       struct('xMin', -100, 'xMax', 100, ...
                              'paramRanges', ...
                              [0 100; -100 100; -100 100; -100 100]'));

  if nargin == 0 % Called with no params
    a_ps = struct;
    a_ps = class(a_ps, 'param_tau_v', ...
                 param_func(var_names, repmat(NaN, 1, length(param_names)), param_names, func_handle, '', props));
  elseif isa(param_init_vals, 'param_tau_v') % copy constructor?
    a_ps = param_init_vals;
  else
    a_ps = struct;
    a_ps = class(a_ps, 'param_tau_v', ...
                 param_func(var_names, param_init_vals, param_names, ...
                           func_handle, id, props));
  end

