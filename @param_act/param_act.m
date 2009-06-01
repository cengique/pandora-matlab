function a_ps = param_act(param_init_vals, id, props)
  
% param_act - Holds parameters of an (in)activation function, y = logsig(-(x+p(1))/p(2)).
%
% Usage:
%   a_ps = param_act(param_init_vals, id, props)
%
% Parameters:
%   param_init_vals: Initial values of function parameters, p = [V_half k].
%   id: An identifying string for this function.
%   props: A structure with any optional properties.
% 	   (Rest passed to param_func)
%		
% Returns a structure object with the following fields:
%	param_func.
%
% Description:  
%   Specialized version (subclass) of param_func for activation and
% inactivation curves.
%
% Additional methods:
%	See methods('param_act')
%
% See also: param_func, param_gate_inf, tests_db, plot_abstract
%
% $Id: param_act.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2009/05/29

  var_names = {'voltage [mV]', 'activation'};
  param_names = {'V_half', 'k'};
  func_handle = @(p,x) deal(1./(1 + exp((x-p(1)) ./ p(2))), NaN);

  if ~ exist('props', 'var')
    props = struct;
  end

  props = mergeStructs(props, struct('xMin', -100, 'xMax', 100));

  if nargin == 0 % Called with no params
    a_ps = struct;
    a_ps = class(a_ps, 'param_act', ...
                 param_func(var_names, [], param_names, func_handle, '', props));
  elseif isa(param_init_vals, 'param_act') % copy constructor?
    a_ps = param_init_vals;
  else
    a_ps = struct;
    a_ps = class(a_ps, 'param_act', ...
                 param_func(var_names, param_init_vals, param_names, ...
                           func_handle, id, props));
  end

