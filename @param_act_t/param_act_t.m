function a_ps = param_act_t(V_pre, V_now, a_param_m_inf_v, a_param_tau_v, id, props) 
  
% param_act_t - An (in)activation function response to a voltage step.
%
% Usage:
%   a_ps = param_act_t(V_pre, V_now, a_param_m_inf_v, a_param_tau_v, id, props)
%
% Parameters:
%   V_pre, V_now: Previous and current holding voltages used to find values of
%   		m0 and minf.
%   a_param_m_inf_v, a_param_tau_v: param_act objects for finding V-dep
%   		act values for minf and tau.
%   id: An identifying string for this function.
%   props: A structure with any optional properties.
% 	   (Rest passed to param_func)
%		
% Returns a structure object with the following fields:
%	m_inf, tau, param_func.
%
% Description:    
%   Specialized version (subclass) of param_func for time profile of
% activation and inactivation variables m and h. The function is m = m0 +
% (minf-m0)*(1-exp(-t/tau)). m0, minf and tau are the parameters and t is
% the function variable.
%
% Additional methods:
%	See methods('param_act_t')
%
% See also: param_func, param_act, tests_db, plot_abstract
%
% $Id: param_act_t.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2009/06/02

% TODO: rename class to V_step
  
  var_names = {'time [ms]', 'activation'};
  param_names = {'m0', 'minf', 'tau'};
  func_handle = @act_func;

  if ~ exist('props', 'var')
    props = struct;
  end

  props = mergeStructs(props, struct('xMin', 0, 'xMax', 100));

  if nargin == 0 % Called with no params
    a_ps = struct;
    a_ps.m_inf = param_act;
    a_ps.tau = param_tau_v;
    a_ps = class(a_ps, 'param_act_t', ...
                 param_func(var_names, [], param_names, func_handle, '', props));
  elseif isa(V_pre, 'param_act_t') % copy constructor?
    a_ps = V_pre;
  else
    a_ps = struct;
    a_ps.m_inf = a_param_m_inf_v;
    a_ps.tau = a_param_tau_v;
    
    if length(V_pre) == 1 && length(V_now) > 1
      V_pre = repmat(V_pre, size(V_now));
    end
    
    % set initial values
    param_init_vals = ...
        [f(a_param_m_inf_v, V_pre), f(a_param_m_inf_v, V_now), ...
         f(a_param_tau_v, V_now)];
    
    a_ps = class(a_ps, 'param_act_t', ...
                 param_func(var_names, param_init_vals, param_names, ...
                           func_handle, id, props));
  end
end

function [act dact_dt] = act_func(p, t)
  time_ones = ones(1, length(t));
  act = p(:, 1) * time_ones + (p(:, 2) - p(:, 1)) * time_ones .* ...
        (1-exp(-repmat(t, size(p, 1), 1) ./ (p(:, 3) * time_ones)));
  dact_dt = NaN;
end