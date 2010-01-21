function a_pf = param_act_int_v(ap_inf_v, ap_tau_v, id, props) 
  
% param_act_int_v - An (in)activation function integrated over a changing V.
%
% Usage:
%   a_pf = param_act_int_v(ap_inf_v, ap_tau_v, id, props)
%
% Parameters:
%   ap_inf_v, ap_tau_v: param_act objects for inf(v) and tau(v), resp.
%   id: An identifying string for this function.
%   props: A structure with any optional properties.
% 	   (Rest passed to param_func)
%		
% Returns a structure object with the following fields:
%	param_mult: Holds the inf and tau functions.
%
% Description:
%   Defines a function f(a_pf, {v, dt}) where v is an array of voltage
% values [mV] changing with dt time steps [ms]. The (in)activation is then
% is the result of the integration of dm = (inf-m)/tau for each value of
% v. Initial value is taken from the first voltage value.
%
% See also: param_mult, param_func, param_act, tests_db, plot_abstract
%
% $Id: param_act_int_v.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2009/12/11
  
% TODO:
% - allow setting initial value rather than taking it from v(1)

  if ~ exist('props', 'var')
    props = struct;
  end
  
  a_pf = ...
      param_mult(...
        {'time [ms]', 'activation'}, ...
        [], {}, ...
        struct('inf', ap_inf_v, ...
               'tau', ap_tau_v), ...
        @act_func_int, id, props);
  
  function [act dact_dt] = act_func_int(fs, p, v_dt)
    v = v_dt{1};
    dt = v_dt{2};
    [t_tmp, act] = ...
        ode15s(@(t,m) ((f(fs.inf, v(floor(t/dt)+1)) - m) / ...
                       f(fs.tau, v(floor(t/dt)+1))), ...
                       (0:(length(v) - 1))*dt, f(fs.inf, v(1)));
    dact_dt = NaN;
  end

end

