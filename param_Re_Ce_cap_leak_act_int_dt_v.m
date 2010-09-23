function a_pf = param_Re_Ce_cap_leak_act_int_dt_v(param_init_vals, id, props) 
  
% param_Re_Ce_cap_leak_int_t - DOESN'T WORK. Membrane capacitance, leak and active channels integrated over time with a model of electrode resistance and capacitance.
%
% Usage:
%   a_pf = param_Re_Ce_cap_leak_act_int_dt_v(param_init_vals, id, props)
%
% Parameters:
%   param_init_vals: Array or structure with initial values for electrode
%     resistance, 'Re' [MOhm], and capacitance, 'Ce' [nF]; leak conductance, 'gL'
%     [uS]; leak reversal, 'EL' [mV]; cell capacitance, 'Cm' [nF], a 'delay'
%     [ms], and a current "offset" [nA].
%   id: An identifying string for this function.
%   props: A structure with any optional properties.
%     v_dep_I_f: Component to simulate Vm-dependent currents. That is, a
%     	         param_func with struct('v', V [mV], 'dt', dt [ms]) -> I [nA].
%     ReFunc: A param_func of voltage difference on Re.
%     (Rest passed to param_mult)
%		
% Returns:
%	a_pf: a param_mult object.
%
% Description:
%   Defines a function f(a_pf, struct) where v is an array of voltage
% values [mV] changing with dt time steps [ms]. Corrected voltage clamp
% protocol compared to param_Re_Ce_cap_leak_act_int_t
%
% See also: param_Re_Ce_cap_leak_act_int_t , param_cap_leak_int_t
%
% Example:
% >> f_capleak = ...
%    param_Re_Ce_cap_leak_int_t(struct('Re', 100, 'Ce', 1, 'gL', 3, 'EL', ...
%                                      -80, 'Cm', 1e-2, delay, .1), ...
%                        ['cap, leak, Re, Ce']);
%
% $Id: param_Re_Ce_cap_leak_int_t.m 131 2010-06-12 04:02:36Z cengiz $
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
      [ eps eps eps -100 eps 0  -.2;...
        1e3 1e3 1e3 -50 1e3  10  .2];
  
  funcs = ...
      struct('I', getFieldDefault(props, 'v_dep_I_f', param_func_nil(0)));

  Re_is_func = false;
  if isfield(props, 'ReFunc')
    Re_is_func = true;
    funcs.Re = props.ReFunc
  end
  
  % make a sub param_func for membrane derivative
  mem_pf = ...
      param_mult(...
        {'time [ms]', 'I_m [nA]'}, ...
        param_init_vals, {}, ...
        funcs, ...
        @mem_deriv, ...
        'Membrane derivative with Re', ...
        mergeStructs(props, struct('isIntable', 1, 'name', 'Im', ...
                                   'paramRanges', param_ranges, ...
                                   'init_val_func', @(a,x) 0)));
  
  a_pf = ...
      param_mult(...
        {'time [ms]', 'I_c [nA]'}, ...
        [], [], ...
        struct('Im', mem_pf), ...        
        @cap_leak_int, id, ...
        mergeStructs(props, struct));

  function dImdt = mem_deriv(fs, p, x)
  % get a handle with fixed parameters first
  %f_I_h = fHandle(fs.I);
    
    Im = getVal(x.s, 'Im');

    if Re_is_func
      Re = f(fs.Re, abs(Im));
    else
      Re = p.Re;
    end

    t_offset = round(x.t/x.dt) + 1;
    Vm = x.v(t_offset, :) - Re * Im;

% $$$     dImdt = ...
% $$$         ((Vm - p.EL) * p.gL + f(fs.I, struct('t', x.t, 'v', Vm, 'dt', x.dt, 's', x.s)) ) / ( p.Cm * Re) ...
% $$$          + ( x.v(t_offset, :) - x.v(max(t_offset - 1, 1), :) ) / x.dt / Re; 

    dImdt = ...
        ( p.Cm / Re) * ( x.v(t_offset, :) - x.v(max(t_offset - 1, 1), :) ) / x.dt / ...
        ((Vm - p.EL) * p.gL + f(fs.I, struct('t', x.t, 'v', Vm, 'dt', x.dt, 's', x.s)) ) - 1 / Re; 

    % TODO: 
    % - fix crude estimate of 1st derivative 
    % - return parts of the equation separately
    
  end
        
  function Ic = cap_leak_int(fs, p, x)
    Vc = x.v;
    dt = x.dt;
    s = getFieldDefault(x, 's', []);
    t = getFieldDefault(x, 't', 0);

    Im_p = getParamsStruct(fs.Im);

    % do the delay as float and interpolate Vc so that the fitting
    % algorithm can move it around
    delay_dt = Im_p.delay/dt;
    delay_dt_int = floor(delay_dt);
    delay_dt_frac = delay_dt - delay_dt_int;

    % prefix some data to reach steady-state
    fixed_delay = round(1/dt);

    % make a new vector for delayed voltage
    Vc_delay = ...
        [ repmat(Vc(1, :), fixed_delay + delay_dt_int + 1, 1); ...
          Vc(2:(end-delay_dt_int), :) - ...
          delay_dt_frac * ...
          diff(Vc(1:(end-delay_dt_int), :)) ];
    
    if isempty(s)
      s = solver_int({}, dt, [ 'solver for ' id ] );
      % add variables and initialize
      s = initSolver(fs.this, s, struct('initV', Vc_delay(1))); % , [-70 0 .85]); 
      var_int = integrate(s, Vc_delay);
      Im = squeeze(var_int(:, 1, :));
      if isfield(s.vars, 'm')
        m = squeeze(var_int(:, 2, :));
        h = squeeze(var_int(:, 3, :));
      end
    else
      % otherwise this is part of a bigger integration, just return
      % values for this time step
      % TODO: this is not going to work as is. Need to address into Vc using t.
      %m = getVal(s, 'm');
      %h = getVal(s, 'h');
      %v_val = v(round(t/dt)+1, :);
    end

    Ic = Im; % + Im_p.Ce * [diff(Vc_delay); zeros(1, size(Vc, 2))] / dt;
    
    % crop the prepended fixed_delay
    Ic = Ic((fixed_delay + 1):end, :);
    
  end

end

