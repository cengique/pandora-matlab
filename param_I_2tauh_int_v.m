function a_pf = ...
      param_I_2tauh_int_v(param_vals, a_param_act, a_param_inact, a_param_inact2, id, props)
  
% param_I_2tauh_int_v - An (non)inactivating current integrated over a changing V.
%
% Usage:
%   a_pf = 
%     param_I_2tauh_int_v(param_vals, a_param_act, a_param_inact, a_param_inact2, id, props)
%
% Parameters:
%   param_vals: Values for p, gmax [uS], E [mV] and a tau weight factor
%   	(f*tauh1+(1-f)*tauh2). q is always 1.
%   a_param_act, a_param_inact, a_param_inact2: param_act objects 
%       for m, h and h2 obtained using the param_act_deriv_v function.
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
% Shal current has two inactivation time constants:
% >> m_Shal = param_act_deriv_v(f_IShal_minf_v, f_IShal_tau_v, 'm');
% >> h_Shal = param_act_deriv_v(f_IShal_hinf_v, f_IShal_htau_v, 'm');
% >> h2_Shal = param_act_deriv_v(f_IShal_hinf_v, f_IShal_h2tau_v, 'm');
% >> f_IShal_v = param_I_2tauh_int_v([1 -80 0.5], m_Shal, h_Shal, h2_Shal, 'I_Shal');
%
% See also: param_I_int_v, param_act_deriv_v, param_func, tests_db, plot_abstract
%
% $Id: param_I_2tauh_int_v.m 128 2010-06-07 21:36:08Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/01/17

  props = defaultValue('props', struct);
  id = defaultValue('id', ''); % complain if id is not supplied?

  props = mergeStructs(props, ...
                       struct('paramRanges', ...
                              [0 4; 0 1e3; -100 100; 0 1]'));
  
  a_pf = ...
    param_mult(...
      {'time [ms]', 'current [nA]'}, ...
      [param_vals], {'p', 'gmax', 'E', 'fh'}, ...
      struct('m', a_param_act, 'h', a_param_inact, 'h2', a_param_inact2), ...
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
        h1 = squeeze(var_int(:, 2, :));
        h2 = squeeze(var_int(:, 3, :));
      else
        h1 = 1;
        h2 = 1;
      end
      v_val = v;
    else
      % otherwise this is part of a bigger integration, just return
      % values for this time step
      m = getVal(s, 'm');
      h1 = getVal(s, 'h');
      h2 = getVal(s, 'h2');
      v_val = v; %(round(t/dt)+1, :); % it already gets only this v value??
    end
    I = p.gmax * ...
        m .^ p.p .* ...
        (h1 * p.fh + h2 * (1 - p.fh)) .*...
        (v - p.E);

end

end
