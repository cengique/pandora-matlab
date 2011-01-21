function a_ps = param_func_const(unit_name, param_val, id, props)
  
% param_func_const - Constant function with parameter, a.
%
% Usage:
%   a_ps = param_func_const(unit_name, param_val, id, props)
%
% Parameters:
%   unit_name: A string with unit of the constant for display purposes
%              (e.g., 'time constant [ms]').
%   param_val: Initial values of function parameter, a.
%   id: A string identifying this function.
%   props: A structure with any optional properties.
% 	   (Rest passed to param_func)
%		
% Returns:
%	a_ps: param_func.
%
% Description:
%
% Example:
% $ a_ps = param_func_const('unitless', 1, 'multiplier')
%
% See also: param_func, param_tau_spline_v, param_tau_2sigmoids_v
%
% $Id: param_func_const.m 128 2010-06-07 21:36:08Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/01/18

  var_names = {'', unit_name};
  param_names = {'a'};
  func_handle = @(p,x) repmat(p.a, size(x));

  if ~ exist('props', 'var')
    props = struct;
  end
  
  a_ps = ...
      param_func(var_names, param_val, param_names, func_handle, id, props);
