function a_pf = param_act_deriv_ab_v(param_init_vals, id, props) 
  
% param_act_deriv_ab_v - Derivative of an (in)activation alpha/beta function that changes with V.
%
% Usage:
%   a_pf = param_act_deriv_ab_v(param_init_vals, id, props)
%
% Parameters:
%   param_init_vals: Array or structure with initial values for
%   	alpha and beta functions: positive constants a0, b0, and
%   	skewness 0 <= delta <= 1 (0.5 makes it symmetric); slope k
%   	in [mV]. a0 and b0 can be calculated automatically if V_half and
%   	tau0 are provided in the parameter structure.
%   ap_inf_v, ap_tau_v: param_act objects for inf(v) and tau(v) in [ms], resp.
%   id: An identifying string for this function.
%   props: A structure with any optional properties.
%     name: Variable name to use in solver (will be superceded by
%     	    param_mult name of this object).
%     VmName: Use this solver variable for voltage signal.
%     (Rest passed to param_func)
%		
% Returns a structure object with the following fields:
%	param_mult: Holds the inf and tau functions.
%
% Description:
%   As opposed to modeling inf (2 parameters) and tau (4
% parameters) functions separately with a total of 6 parameters,
% this function has the advantage of only having 3 parameters to
% represent an (in)activation variable. It implements the
% Hodgkin-Huxley alpha-beta channel formulation summarized in
% Willms, Harris-Warrick, Guckenheimer (1999) as equation 4:
%   alpha(V) = a0 * exp(    - delta  * V / k )
%   beta(V)  = b0 * exp( (1 - delta) * V / k )
% The traditional half-activation is calculated as:
%   V1/2 = -k * ln(b0 / a0)
% From these functions, tau and inf functions are derived to be
% used in the integration for the (in)activation variable:
%   dm = (inf(V)-m)/tau(V)
% for each value of v. Defines a function f(a_pf, struct('v', V
% [mV], 'dt', dt [ms])) where v is an array of voltage values [mV]
% changing with dt time steps [ms]. Initial value is taken from the
% first voltage value. 
%
% See also: param_act_deriv_ab_v, param_act, tests_db, plot_abstract
%
% $Id: param_act_deriv_ab_v.m 128 2010-06-07 21:36:08Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2015/05/22
  
% TODO:
% - allow setting initial value rather than taking it from v(1)

  props = defaultValue('props', struct);
  id = defaultValue('id', ''); % complain if not supplied?

  % for inner function
  props.name = getFieldDefault(props, 'name', id);

  calc_a0 = ...
      @(V_half, k, delta, tau0) ...
      exp(delta * V_half / k) / tau0;
  calc_b0 = ...
      @(V_half, k, delta, tau0) ...
      exp((delta - 1) * V_half / k) / tau0;
  
  % calc some defaults
  V_half = -40;
  k = 4;
  delta = 0.5;
  tau0 = 10;
  param_defaults = ...
      struct('a0', calc_a0(V_half, k, delta, tau0), ...
             'b0', calc_b0(V_half, k, delta, tau0), ...
             'delta', delta, 'k', k);

  if ~ isstruct(param_init_vals)
    param_init_vals = ...
        cell2struct(num2cell(param_init_vals(:)'), ...
                    fieldnames(param_defaults), 2);
  else
    % check if alternate form is used
    if isfield(param_init_vals, 'V_half')
      disp('Converting parameters from:');
      disp(param_init_vals)
      param_init_vals.a0 = ...
          calc_a0(param_init_vals.V_half, param_init_vals.k, ...
                  param_init_vals.delta, param_init_vals.tau0);
      param_init_vals.b0 = ...
          calc_b0(param_init_vals.V_half, param_init_vals.k, ...
                  param_init_vals.delta, param_init_vals.tau0);
      param_init_vals = ...
          rmfield(param_init_vals, {'V_half', 'tau0'});
      disp('Converted to:')
      disp(param_init_vals)
    end
    
    % use defaults for non-specified parameters
    param_init_vals = ...
        mergeStructs(param_init_vals, param_defaults);
    % make sure they're ordered consistently to match the range description
    param_init_vals = ...
        orderfields(param_init_vals, param_defaults);
  end
  
  % physiologic parameter ranges
  param_ranges = ...
      [ 0   0   0 -1e3;...
        1e3 1e3 1  1e3];

  % put a default name, but can be overwritten if object is added to
  % solver by a param_mult object. Then, variable name inside param_mult
  % is used as the name.
  if isempty(props.name), props.name = 'm'; end
  
  a_pf = ...
      param_func(...
        {'time [ms]', 'activation'}, ...
        param_init_vals, [], ...
        @(p, x) feval(deriv_func(p, getFieldDefault(x, 'k', [])), p, x), id, ...
        mergeStructs(props, struct('isIntable', 1, ...
                                   'fHandle', @deriv_func, ...
                                   'init_val_func', ...
                                   @(s, v) m_inf(v))));

% only used for initialization
function m_inf = m_inf(Vm)
  [dm_dt alpha beta] = deriv_Vm_func(getParamsStruct(a_pf), Vm, 0);
  m_inf = 1 / (1 + beta / alpha);
end

% TODO: this should be an object of deriv_func, which should be a
% subclass of param_mult, where the f function is overloaded to do the
% integration.

function [dm_dt alpha beta] = deriv_Vm_func(p, Vm, m)
% Calculates derivative from inputs. No logic, just calculations. 
  alpha = p.a0 * exp(   - p.delta  * Vm / p.k);
  beta  = p.b0 * exp((1 - p.delta) * Vm / p.k);

  dm_dt = (alpha + beta) * (1 / (1 + beta / alpha) - m);
end

function dfunc_handle = deriv_func(p, s)
% separated to extract Vm name only once
  fs_props = get(a_pf, 'props');
  if isfield(fs_props, 'VmName')
    % this can be made faster if getVal is not used
    v_str = [ 'getVal(x.s, ''' fs_props.VmName ''')' ];
  else
    v_str = 'x.v';
  end
  props = get(a_pf, 'props');
  if isempty(s)
    % return function that initiates integration
    dfunc_handle = @(p, x) squeeze(integrate(a_pf, x, props));
  else
    % return derivative without logic above
    dfunc_handle = @(p, x) deriv_Vm_func(p, eval(v_str), getVal(x.s, props.name));
  end
end
end
