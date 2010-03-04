function a_pf = param_cap_leak_int_t(param_init_vals, id, props) 
  
% param_cap_leak_int_t - Membrane capacitance and leak integrated over time.
%
% Usage:
%   a_pf = param_cap_leak_int_t(ap_inf_v, ap_tau_v, id, props)
%
% Parameters:
%   param_init_vals: Array or structure with initial values for Ri,
%     Series resistance [MOhm]; gL, leak conductance [uS]; EL, leak
%     reversal [mV]; and Cm, cell capacitance [nF]. 
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
% Example:
% >> f_capleak = ...
%    param_cap_leak_int_t(struct('Ri', 100, 'gL', 3, 'EL', -80, 'Cm', 1e-2), ...
%                        ['Ca chan 3rd instar cap leak']);
%
% $Id: param_cap_leak_int_t.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/03/02
  
  if ~ exist('props', 'var')
    props = struct;
  end
  
  if ~ isstruct(param_init_vals)
    param_init_vals = ...
        cell2struct(num2cell(param_init_vals(:)), ...
                    {'Ri', 'gL', 'EL', 'Cm'}, 2);
  end
  
  a_pf = ...
      param_func(...
        {'time [ms]', 'I_{cap+leak} [nA]'}, ...
        param_init_vals, [], ...
        @cap_leak_int , id, props);
  
  function [Im, dIdt] = cap_leak_int(p, v_dt)
    v = v_dt{1};
    dt = v_dt{2};
    [t_tmp, Vm] = ...
        ode15s(@(t, Vm) ((Vm-p.EL)* p.gL + (v(floor(t/dt)+1) - Vm) ...
                         / p.Ri )/ p.Cm, ...
               (0:(length(v) - 1))*dt, v(1));
    % after solving Vm, return total membrane current
    Im = ((Vm-p.EL)* p.gL + (v - Vm) / p.Ri );
    dIdt = NaN;
  end

end

