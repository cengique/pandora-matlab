function a_pf = param_act_deriv_v(ap_inf_v, ap_tau_v, id, props) 
  
% param_act_deriv_v - Derivative of an (in)activation function that changes with V.
%
% Usage:
%   a_pf = param_act_deriv_v(ap_inf_v, ap_tau_v, id, props)
%
% Parameters:
%   ap_inf_v, ap_tau_v: param_act objects for inf(v) and tau(v) in [ms], resp.
%   id: An identifying string for this function.
%   props: A structure with any optional properties.
%     name: Variable name to use in solver (will be superceded by
%     	    param_mult name of this object).
%     (Rest passed to param_func)
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

  props = defaultValue('props', struct);
  id = defaultValue('id', ''); % complain if not supplied?

  % for inner function
  props.name = getFieldDefault(props, 'name', id);

  % put a default name, but can be overwritten if object is added to
  % solver by a param_mult object. Then, variable name inside param_mult
  % is used as the name.
  if isempty(props.name), props.name = 'm'; end
  
  a_pf = ...
      param_mult(...
        {'time [ms]', 'activation'}, ...
        [], {}, ...
        struct('inf', ap_inf_v, ...
               'tau', ap_tau_v), ...
        @act_func_deriv, id, mergeStructs(props, struct('isIntable', 1, ...
                                                    'init_val_func', ...
                                                    @(fs, v) f(fs.inf, v))));

% TODO: this should be an object of deriv_func, which should be a
% subclass of param_mult, where the f function is overloaded to do the
% integration.

% TODO: simplify this function, running too slow again! Make it return a
% string description of the function

  function dact = act_func_deriv(fs, p, x)
    s = getFieldDefault(x, 's', []);
    fs_props = get(fs.this, 'props');
    if isfield(fs_props, 'VmName')
      v = getVal(s, fs_props.Vm);
    else
      v = x.v;
    end
    t = getFieldDefault(x, 't', 0);
    dt = x.dt;
    props = get(fs.this, 'props');
    if isempty(s)
      s = solver_int({}, dt, [ 'solver for ' id ] );
      s = initSolver(fs.this, s, struct('initV', v(1)));
      var_int = integrate(s, v, mergeStructs(get(fs.this, 'props'), props));
      % return integrated variable
      dact = squeeze(var_int(:, 1, :));
    else
      % return derivative
      dact = (f(fs.inf, v) - getVal(s, props.name)) ./ ...
              f(fs.tau, v); 
    end
  end
end
