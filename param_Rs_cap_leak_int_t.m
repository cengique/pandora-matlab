function a_pf = param_cap_leak_int_t(param_init_vals, id, props) 
  
% param_cap_leak_int_t - Membrane capacitance and leak integrated over time.
%
% Usage:
%   a_pf = param_cap_leak_int_t(param_init_vals, id, props)
%
% Parameters:
%   param_init_vals: Array or structure with initial values for 
%     series resistance, Rs [MOhm]; leak conductance, gL [uS]; leak
%     reversal, EL [mV]; cell capacitance, Cm [nF], and a delay [ms]. 
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
%    param_cap_leak_int_t(struct('Rs', 100, 'gL', 3, 'EL', -80, 'Cm', 1e-2), ...
%                        ['Ca chan 3rd instar cap leak']);
%
% $Id: param_cap_leak_int_t.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/03/02
  
% TODO:
  
  if ~ exist('props', 'var')
    props = struct;
  end

  if ~ exist('id', 'var')
    id = '';
  end

  param_names_ordered = {'Rs', 'gL', 'EL', 'Cm', 'delay'};
  if ~ isstruct(param_init_vals)
    param_init_vals = ...
        cell2struct(num2cell(param_init_vals(:)'), ...
                    param_names_ordered, 2);
  else
    % make sure they're ordered consistently to match the range description
    param_init_vals = ...
        orderfields(param_init_vals, param_names_ordered);
  end
  
  % physiologic parameter ranges
  param_ranges = ...
      [ eps eps -100 eps 0;...
        1e3 1e3 -50 1e3  10];
  
  a_pf = ...
      param_func(...
        {'time [ms]', 'I_{cap+leak} [nA]'}, ...
        param_init_vals, [], ...
        @cap_leak_int, id, ...
        mergeStructs(props, struct('paramRanges', param_ranges)));
  
  function [Im, dIdt] = cap_leak_int(p, v_dt)
    Vc = v_dt{1};
    dt = v_dt{2};
    
    % do the delay as float and interpolate Vc so that the fitting
    % algorithm can move it around
    delay_dt = p.delay/dt;
    delay_dt_int = floor(delay_dt);
    delay_dt_frac = delay_dt - delay_dt_int;

    % prefix some data to reach steady-state
    fixed_delay = round(2/dt);

    % make a new vector for delayed voltage
    Vc_delay = ...
        [ repmat(Vc(1, :), fixed_delay + delay_dt_int + 1, 1); ...
          Vc(2:(end-delay_dt_int), :) - ...
          delay_dt_frac * ...
          diff(Vc(1:(end-delay_dt_int), :)) ];

    [t_tmp, Vm] = ...
        ode15s(@(t, Vm) ...
               (- (Vm - p.EL) * p.gL + ...
                (Vc_delay(round(t/dt) + 1, :)' - Vm) / p.Rs ) / p.Cm, ...
        (0:(size(Vc_delay, 1) - 1))*dt, Vc(1, :));
    
    % after solving Vm, return total input current (except manual
    % correction for leak at -70 mV)
    Im = (Vc_delay - Vm) / p.Rs - ...
         ones(size(Vc_delay, 1), 1) * (Vc_delay(fixed_delay, :) - Vm(fixed_delay, :)) / p.Rs;
    %ones(size(Vc, 1), 1) * (Vm(fixed_delay, :) - p.EL) * p.gL;
    
    % crop the fixed_delay part
    Im = Im((fixed_delay + 1):end, :);

    dIdt = NaN;
  end

end

