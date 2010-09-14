function a_pf = param_act_deriv_v(ap_inf_v, ap_tau_v, id, props) 
  
% param_act_deriv_v - Derivative of an (in)activation function that changes with V.
%
% Usage:
%   a_pf = param_act_deriv_v(ap_inf_v, ap_tau_v, id, props)
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
%   Defines a function f(a_pf, struct('v', V [mV], 'dt', dt [ms])) where v is an array of voltage
% values [mV] changing with dt time steps [ms]. The (in)activation is then
% is the result of the integration of dm = (inf-m)/tau for each value of
% v. Initial value is taken from the first voltage value.
%
% See also: param_mult, param_func, param_act, tests_db, plot_abstract
%
% $Id: param_act_deriv_v.m 128 2010-06-07 21:36:08Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2009/12/11
  
% TODO:
% - allow setting initial value rather than taking it from v(1)

  if ~ exist('props', 'var')
    props = struct;
  end

  % for inner function
  name = getFieldDefault(props, 'name', id);

  a_pf = ...
      param_mult(...
        {'time [ms]', 'activation'}, ...
        [], {}, ...
        struct('inf', ap_inf_v, ...
               'tau', ap_tau_v), ...
        @act_func_deriv, id, mergeStructs(props, struct('isIntable', 1, ...
                                                    'init_val_func', ...
                                                    @(fs, v) f(fs.inf, v))));


  function dact = act_func_deriv(fs, p, x)
    t = x.t;
    s = x.s;
    v = x.v;
    dt = x.dt;
    dact = ((f(fs.inf, v(round(t/dt)+1, :)') - getVal(s, name)) ./ ...
            f(fs.tau, v(round(t/dt)+1, :)'));
  end
end
