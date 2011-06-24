function a_pm = ...
      param_HH_chan_int_v(param_vals, a_param_act, a_param_inact, id, props)
  
% param_HH_chan_int_v - Hodgkin-Huxley type (non)inactivating current integrated over a changing V.
%
% Usage:
%   a_pm = 
%     param_HH_chan_int_v(param_vals, a_param_act, a_param_inact, id, props)
%
% Parameters:
%   param_vals: Values for p, gmax [uS], E [mV] and fh, a tau weight factor
%   	(fh*tauh1+(1-fh)*tauh2). q is always 1.
%   a_param_act, a_param_inact: param_act_deriv_v objects for m and h, resp.,
%   	obtained using the param_act_int_v function.
%   id: An identifying string for this function.
%   props: A structure with any optional properties.
%     h2: param_act_deriv_v function for 2nd inactivation.
%     (Rest passed to param_func)
%		
% Returns a structure object with the following fields:
%	param_mult: Holds the voltage->current function.
%
% Description:
%   Subclass of param_mult. Defines  a function f(a_pm, struct('v',  V [mV],
% 'dt', dt [ms])) where  v is an array of  voltage values [mV] changing with
% dt  time steps [ms].  Initial values for  the  activation and inactivation
% variables are calculated from the first voltage value.
%
% Example:
% >> m_ClCa = param_act_int_v(f_IClCa_minf_v, f_IClCa_tau_v, 'm');
% >> f_IClCa_v = param_HH_chan_int_v([1 0 1 -41.7], m_ClCa, param_func_nil, 'I_ClCa');
% Shal current has two inactivation time constants:
% >> m_Shal = param_act_deriv_v(f_IShal_minf_v, f_IShal_tau_v, 'm');
% >> h_Shal = param_act_deriv_v(f_IShal_hinf_v, f_IShal_htau_v, 'm');
% >> h2_Shal = param_act_deriv_v(f_IShal_hinf_v, f_IShal_h2tau_v, 'm');
% >> f_IShal_v = param_HH_chan_int_v([1 -80 0.5], m_Shal, h_Shal,
% 		                    'I_Shal', struct('h2', h2_Shal));
%
% See also: param_act_int_v, param_func, tests_db, plot_abstract
%
% $Id: param_HH_chan_int_v.m 128 2010-06-07 21:36:08Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/01/27

if nargin == 0 % Called with no params
  a_pm = struct;
  a_pm = class(a_pm, 'param_HH_chan_int_v', param_mult);
  return;
elseif isa(param_vals, 'param_HH_chan_int_v') || isa(param_vals, 'param_mult')
  % copy constructor? accept even param_mult which may be coming from param_I_int_v.
  % then initialize input params to create a new param_HH_chan_int_v object from it.
  a_param_act = get(param_vals, 'm');
  a_param_inact = get(param_vals, 'h');
  id = get(param_vals, 'id');
  props = get(param_vals, 'props');
  params = getParamsStruct(param_vals);
  try
    props.h2 = get(param_vals, 'h2');
    fh = params.fh;
  catch
    fh = 1;
  end
  param_vals = [params.p params.gmax params.E fh];
  % continue on...
end

props = defaultValue('props', struct);
id = defaultValue('id', ''); % complain if not supplied?

sub_funcs = struct('m', a_param_act, 'h', a_param_inact);

if isfield(props, 'h2')
  sub_funcs.h2 = props.h2;
  func = @I_int_2h;
else
  func = @I_int;
end

props = mergeStructs(props, ...
                     struct('paramRanges', ...
                            [0 4; 0 10e3; -200 200; 0 1]'));

a_pm = struct;
a_pm = class(a_pm, 'param_HH_chan_int_v', ...
             param_mult(...
               {'time [ms]', 'current [nA]'}, ...
               [param_vals], {'p', 'gmax', 'E', 'fh'}, ...
               sub_funcs, ...
               @I_int, id, props));

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
      h = getVal(s, 'h');
      v_val = v; %(round(t/dt)+1, :); % it already gets only this v value??
    end
    I = p.gmax * ...
        m .^ p.p .* ...
        h .* ...
        (v - p.E);

end

function I = I_int_2h (fs, p, x)
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
