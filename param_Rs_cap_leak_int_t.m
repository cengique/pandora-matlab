function a_pf = param_cap_leak_int_t(param_init_vals, id, props) 
  
% param_cap_leak_int_t - Membrane capacitance and leak integrated over time.
%
% Usage:
%   a_pf = param_cap_leak_int_t(param_init_vals, id, props)
%
% Parameters:
%   param_init_vals: Array or structure with initial values for 
%     series resistance, Ri [MOhm]; leak conductance, gL [uS]; leak
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
%    param_cap_leak_int_t(struct('Ri', 100, 'gL', 3, 'EL', -80, 'Cm', 1e-2), ...
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

  param_names_ordered = {'Ri', 'gL', 'EL', 'Cm', 'delay'};
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
      [ eps eps -200 eps 0;...
        1e3 1e3 100 1e3  10];
  
  a_pf = ...
      param_func(...
        {'time [ms]', 'I_{cap+leak} [nA]'}, ...
        param_init_vals, [], ...
        @cap_leak_int, id, ...
        mergeStructs(props, struct('paramRanges', param_ranges)));
  
  function [Im, dIdt] = cap_leak_int(p, v_dt)
    v = v_dt{1};
    dt = v_dt{2};
    
    Im = repmat(NaN, size(v));
    delay_dt = floor(p.delay/dt + 0.5);
    
    % do columns of data separately
    for col_num = 1:size(v, 2)
      [t_tmp, Vm] = ...
          ode15s(@(t, Vm) ...
                 (- (Vm - p.EL) * p.gL + ...
                  (v(max(floor(t/dt + 0.5) + 1 - delay_dt, 1), col_num) - Vm) / p.Ri ) ...
                 / p.Cm, ...
                 (0:(length(v) - 1))*dt, v(1, col_num));
      % after solving Vm, return total input current
      Im(:, col_num) = ...
          ([repmat(v(1, col_num), delay_dt, 1); ...
            v(1:(end-delay_dt), col_num)] - Vm) / p.Ri;
    end
    dIdt = NaN;
  end

end

