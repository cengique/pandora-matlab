function a_pf = param_cc_Rs_comp_int_t(param_init_vals, id, props) 
  
% param_cc_Rs_comp_int_t - Simulated current clamp amplifier with series resistance compensation attached to an electrode and membrane.
%
% Usage:
%   a_pf = param_cc_Rs_comp_int_t(param_init_vals, id, props)
%
% Parameters:
%   param_init_vals: Array or structure with initial values for electrode
%     resistance, 'Re' [MOhm], and capacitance, 'Ce' [nF]; leak conductance, 'gL'
%     [uS]; leak reversal, 'EL' [mV]; cell capacitance, 'Cm' [nF], a 'delay'
%     [ms], and a current "offset" [nA].
%   id: An identifying string for this function.
%   props: A structure with any optional properties.
%     v_dep_I_f: A voltage-dependent current that is simulated with
%     		Vm. That is, A param_func with struct('v', V [mV], 'dt', dt [ms]) -> I [nA].
%     ReFunc: A param_func of voltage difference on Re.
%     name: Use this to make labels unique.
%     (Rest passed to param_mult)
%		
% Returns:
%	a_pf: a param_mult object.
%
% Description:
%   Implements the Preyer & Butera (2009) 10.1109/TNSRE.2009.2015205
% amplifier current clamp circuit for series resistance (bridge
% balance) and capacitance compensation, together with membrane and
% electrode passive properties. Note that the input signal x.v is
% interpreted as a current command. Defines a function f(a_pf, struct)
% where v is the amplifier command voltage [mV] vector changing with
% dt time steps [ms].
%
% See also: param_Re_Ce_cap_leak_int_t
%
% Example:
% >> f_capleak = ...
%    param_Re_Ce_cap_leak_int_t(struct('Re', 100, 'Ce', 1, 'gL', 3, 'EL', ...
%                                      -80, 'Cm', 1e-2, delay, .1), ...
%                        ['cap, leak, Re, Ce']);
%
% $Id: param_Re_Ce_cap_leak_int_t.m 131 2010-06-12 04:02:36Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2015/05/05
  
% TODO:
% - improve initSolver to accept deriv functions that return
% multiple variables at once  
  
  if ~ exist('props', 'var')
    props = struct;
  end

  if ~ exist('id', 'var')
    id = '';
  end

  param_defaults = struct('Rcur', 100, 'Re', 0.05, 'Ccomp', 1e-3, 'Ce', 5e-3, ...
                          'gL', 1, 'EL', -80, ...
                          'Cm', 10e-3, 'delay', 0, 'offset', 0);
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
      [ 100 eps eps eps eps -120 eps 0  -.2;...
        100 1e3 1   1   1e4 30 1e3  10  .2];
  
  Vm_name = [ getFieldDefault(props, 'name', '') 'Vm' ];
  
  funcs = ...
      struct('I', ...
             setVmName(getFieldDefault(props, 'v_dep_I_f', ...
                                              param_func_nil(0)), ...
                       Vm_name, struct('recursive', 1)));

  Re_is_func = false;
  if isfield(props, 'ReFunc')
    Re_is_func = true;
    funcs.Re = props.ReFunc
  end  
  
  % make a sub param_func that outputs to derivatives: membrane
  % voltage (Vm) and amplifier input voltage (Vi)
  VmVi_pf = ...
      param_mult(...
        {'time [ms]', 'voltage [mV]'}, ...
        param_init_vals, {}, ...
        funcs, ...
        @amp_deriv, ...
        'Membrane derivative with Re', ...
        mergeStructs(props, ...
                     struct('isIntable', 1, 'name', 'Vm_Vi', ...
                            'numVals', 2, ...
                            'paramRanges', param_ranges)));

  a_pf = ...
      param_mult(...
        {'time [ms]', 'I_{cap+leak+electrode} [nA]'}, ...
        [], [], ...
        struct('Vm_Vi', VmVi_pf), ...        
        @amp_int, id, ...
        mergeStructs(props, struct));

  % returns [ dVm/dt; dVi/dt ]
  function dVdt = amp_deriv(fs, p, x)
    Vm_Vi = getVal(x.s, 'Vm_Vi');
    
    % voltage over Re
    V_Re = (Vm_Vi(2)  - Vm_Vi(1)); %x.v(round(x.t/x.dt) + 1, :)'

    if Re_is_func
      Re = f(fs.Re, abs(V_Re));
    else
      Re = p.Re;
    end
    
    I_Re = V_Re / Re;
    
    % this is still weird for me. shouldn't it be (x.v - Vi)?
    I_cur = x.v / p.Rcur; 
    
    dVmdt = ...
        (- (Vm_Vi(1) - p.EL) * p.gL ...
         - f(fs.I, struct('t', x.t, 'v', Vm_Vi(1), 'dt', x.dt, 's', x.s)) ...
         + I_Re ) / p.Cm;
  
    % put all cap compensation together: p.Ccomp * (p.Gc * p.Pcc - 1) + p.Cshunt
    dVidt = (I_cur - I_Re) / (p.Ce - p.Ccomp);
        
    dVdt = [ dVmdt; dVidt ];
  end

  function [I_prep outs] = amp_int(fs, p, x)
    Vc = x.v;
    dt = x.dt;
    s = getFieldDefault(x, 's', []);
    t = getFieldDefault(x, 't', 0);

    Vm_p = getParamsStruct(fs.Vm_Vi);

    if Vm_p.delay < 0 
      warning(['Delay=' num2str(Vm_p.delay) ' ms, but should not be negative! ' ...
                           'Resetting to zero.']);
      Vm_p.delay = 0;
    end
    
    % do the delay as float and interpolate Vc so that the fitting
    % algorithm can move it around
    delay_dt = min(Vm_p.delay/dt, size(Vc, 1) - 1);
    delay_dt_int = floor(delay_dt);
    delay_dt_frac = delay_dt - delay_dt_int;
    
    % prefix some data to reach steady-state
    fixed_delay = round(1/dt);

    % make a new vector for delayed voltage
    Vc_delay = ...
        [ repmat(Vc(1, :), fixed_delay + delay_dt_int + 1, 1); ...
          Vc(2:end-delay_dt_int, :) - ...
          delay_dt_frac * ...
          diff(Vc(1:end-delay_dt_int, :), [], 1) ];
    
    if isempty(s)
      s = solver_int({}, dt, [ 'solver for ' id ] );
      % add variables and initialize. add  [0 1] for m & h
      %s = setVals(
      s = initSolver(fs.this, s, struct('initV', [Vc_delay(1); Vc_delay(1)])); % , [-70 0 .85]); 
      % check initial conditions set based on V only
      var_int = integrate(s, Vc_delay, mergeStructs(get(fs.this, 'props'), props));
      Vm = squeeze(var_int(:, 1, :));
      Vi = squeeze(var_int(:, 2, :));
    end
        
    % after integrating Vi, return total input current
    I_prep = ...
        Vm_p.offset ...
        + (Vm_p.Ce - Vm_p.Ccomp) * [repmat(Vi(1, :), 1, 1); diff(Vi)] ...
        + Vc_delay / Vm_p.Rcur;
            
    if nargout > 1
      outs = ...
          cell2struct(mat2cell(cat(3, I_prep((fixed_delay + 1):end, :), ...
                                   permute(var_int((fixed_delay + 1):end, :, :), ...
                                           [1 3 2])), ...
                               size(var_int((fixed_delay + 1):end, :), 1), ...
                               size(var_int, 3), ...
                               ones(1, size(var_int, 2) + 1)), ...
                      [ 'I_prep'; 'Vm'; fieldnames(s.vars)], 3);
      
    end
    
    % crop the prepended fixed_delay
    I_prep = I_prep((fixed_delay + 1):end, :);

  end

end

