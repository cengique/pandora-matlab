function a_ps = param_tau_2sigmoids_v(param_init_vals, id, props)
  
% param_tau_2sigmoids_v - V-dep time constant product of two sigmoids, y = (a + b/(1+exp((x+c)/d)))*(e + f/(1+exp((x+g)/h))).
%
% Usage:
%   a_ps = param_tau_2sigmoids_v(param_init_vals, id, props)
%
% Parameters:
%   param_init_vals: Initial values of function parameters, p = [a b c d e f g h].
%   id: A string identifying this function.
%   props: A structure with any optional properties.
% 	   (Rest passed to param_func)
%		
% Returns:
%	a_ps: param_func.
%
% Description:
%
% See also: param_func, param_tau_spline_v
%
% $Id: param_tau_2sigmoids_v.m 128 2010-06-07 21:36:08Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/09/29

  var_names = {'voltage [mV]', 'time constant [ms]'};
  param_names = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};
  func_handle = @(p,x) (p.a + p.b./(1 + exp((x+p.c) ./ p.d))) .* (p.e + p.f./(1 + exp((x+p.g) ./ p.h)));

  if ~ exist('props', 'var')
    props = struct;
  end

  sig_param_ranges = ...
      [0 100; -100 100; -100 100; -100 100]';
  props = mergeStructs(props, ...
                       struct('xMin', -100, 'xMax', 100, ...
                              'paramRanges', [sig_param_ranges, sig_param_ranges]));
  
  a_ps = ...
      param_func(var_names, param_init_vals, param_names, ...
                 func_handle, id, props);


