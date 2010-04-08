function a_pf = param_Re_Ce_cap_leak_int_t(param_init_vals, id, props) 
  
% param_Re_Ce_cap_leak_int_t - Membrane capacitance and leak integrated over time with a model of electrode resistance and capacitance.
%
% Usage:
%   a_pf = param_Re_Ce_cap_leak_int_t(param_init_vals, id, props)
%
% Parameters:
%   param_init_vals: Array or structure with initial values for electrode
%     resistance, Re [MOhm], and capacitance, Ce [nF]; leak conductance, gL
%     [uS]; leak reversal, EL [mV]; cell capacitance, Cm [nF], a delay
%     [ms], and a current offset error [nA].
%   id: An identifying string for this function.
%   props: A structure with any optional properties.
% 	   (Rest passed to param_func)
%		
% Returns a structure object with the following fields:
%	param_mult: Holds the inf and tau functions.
%
% Description:
%   Defines a function f(a_pf, {v, dt}) where v is an array of voltage
% values [mV] changing with dt time steps [ms]. 
%
% See also: param_Rs_cap_leak_int_t, param_cap_leak_int_t
%
% Example:
% >> f_capleak = ...
%    param_Re_Ce_cap_leak_int_t(struct('Re', 100, 'Ce', 1, 'gL', 3, 'EL', ...
%                                      -80, 'Cm', 1e-2, delay, .1), ...
%                        ['cap, leak, Re, Ce']);
%
% $Id: param_Re_Ce_cap_leak_int_t.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/03/02
  
% TODO:
  
  if ~ exist('props', 'var')
    props = struct;
  end

  if ~ exist('id', 'var')
    id = '';
  end

  param_defaults = struct('Re', 0.05, 'Ce', 10, 'gL', 1, 'EL', -80, ...
                          'Cm', 10, 'delay', 0, 'offset', 0);
  if ~ isstruct(param_init_vals)
    param_init_vals = ...
        cell2struct(num2cell(param_init_vals(:)'), ...
                    fieldnames(param_defaults), 2);
  else
    % use defaults for non-specified parameters
    param_init_vals = ...
        mergeStructs(param_init_vals, param_defaults);
    % make sure they're ordered consistently to match the range description
    param_init_vals = ...
        orderfields(param_init_vals, param_defaults);
  end
  
  % physiologic parameter ranges
  param_ranges = ...
      [ eps eps eps -100 eps 0  -.1;...
        1e3 1e3 1e3 -50 1e3  10  .1];
  
  a_pf = ...
      param_func(...
        {'time [ms]', 'I_{cap+leak+electrode} [nA]'}, ...
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
                (Vc_delay(round(t/dt) + 1, :)' - Vm) / p.Re ) / p.Cm, ...
        (0:(size(Vc_delay, 1) - 1))*dt, Vc(1, :));
    
    % after solving Vm, return total input current (except manual
    % correction for leak at -70 mV)
    Im = p.offset + ...
         p.Ce * [diff(Vc_delay); zeros(1, size(Vc, 2))] / dt ...
         + (Vc_delay - Vm) / p.Re;% ...
                                  %- ones(size(Vc_delay, 1), 1) * (Vc_delay(fixed_delay, :) - Vm(fixed_delay, :)) / p.Re;
    %ones(size(Vc, 1), 1) * (Vm(fixed_delay, :) - p.EL) * p.gL;
    
    % crop the fixed_delay part
    Im = Im((fixed_delay + 1):end, :);

    dIdt = NaN;
  end

end

