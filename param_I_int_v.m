function a_pf = ...
      param_I_int_v(param_vals, a_param_act, a_param_inact, id, props)
  
% param_I_int_v - An (non)inactivating current integrated over a changing V.
%
% Usage:
%   a_pf = 
%     param_I_int_v(param_vals, a_param_act, a_param_inact, id, props)
%
% Parameters:
%   param_vals: Values for p, q, gmax [uS] and E [mV].
%   a_param_act, a_param_inact: param_act objects for m and h, resp.,
%   	obtained using the param_act_deriv_v function.
%   id: An identifying string for this function.
%   props: A structure with any optional properties.
% 	   (Rest passed to param_func)
%		
% Returns a structure object with the following fields:
%	a_pf: Holds the voltage->current function.
%
% Description:
%   Defines a function f(a_pf, struct('v', V [mV], 'dt', dt [ms])) where v is an array of voltage
% values [mV] changing with dt time steps [ms]. Initial values for the
% activation and inactivation variables are calculated from the first voltage
% value.
%
% Example:
% >> m_ClCa = param_act_int_v(f_IClCa_minf_v, f_IClCa_tau_v, 'm');
% >> f_IClCa_v = param_I_int_v([1 0 1 -41.7], m_ClCa, param_func_nil, 'I_ClCa');
%
% See also: param_act_int_v, param_func, tests_db, plot_abstract
%
% $Id: param_I_int_v.m 128 2010-06-07 21:36:08Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/01/17

  props = defaultValue('props', struct);
  id = defaultValue('id', ''); % complain if not supplied?

  props = mergeStructs(props, ...
                       struct('paramRanges', ...
                              [0 4; 0 4; 0 1e3; -100 100]'));
  
  a_pf = ...
    param_mult(...
      {'time [ms]', 'current [nA]'}, ...
      [param_vals], {'p', 'q', 'gmax', 'E'}, ...
      struct('m', a_param_act, 'h', a_param_inact), ...
      @I_int, id, props);
  
  function I = I_int (fs, p, x)
    s = getFieldDefault(x, 's', []);
    v = x.v;
    t = getFieldDefault(x, 't', 0);
    dt = x.dt;
    if isempty(s)
      s = solver_int({}, dt, [ 'solver for ' id ] );
      s = initSolver(fs.this, s, struct('initV', v(1)));
      var_int = integrate(s, v, mergeStructs(get(fs.this, 'props'), props));
      m = squeeze(var_int(:, 1, :));
      if size(var_int, 2) > 1
        h = squeeze(var_int(:, 2, :));
      else
        h = 1;
      end
      v_val = v;
    else
      % otherwise this is part of a bigger integration, just return
      % values for this time step
      m = getVal(s, 'm');
      if isfield(s.vars, 'h')
        h = getVal(s, 'h');
      else
        h = 1;
      end
      v_val = v; %(round(t/dt)+1, :); % it already gets only this v value??
    end
    I = p.gmax * ...
        m .^ p.p .* ...
        h .^ p.q .* ...
        (v - p.E);

end

end
