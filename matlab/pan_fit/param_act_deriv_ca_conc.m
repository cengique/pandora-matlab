function a_pf = param_act_deriv_ca_conc(ICa, mKCa,tauCa, ratio_sa_vol, resting, props) 
  % pass in the ICa and IKCa objects instead of inf_v tau_v above
% param_act_deriv_v - Derivative of an (in)activation function that changes with V.
%
% Usage:
%   a_pf = param_act_deriv_ca_conc(ap_inf_v, ap_tau_v, id, props)
%
% Parameters:
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
%   Defines a function f(a_pf, struct('v', V [mV], 'dt', dt [ms])) where v is an array of voltage
% values [mV] changing with dt time steps [ms]. The (in)activation is then
% is the result of the integration of dm = (inf-m)/tau for each value of
% v. Initial value is taken from the first voltage value.
%
% See also: param_mult, param_func, param_act, tests_db, plot_abstract
%
% $Id: param_act_deriv_v.m 128 2010-06-07 21:36:08Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2009/12/11
  
% TODO:
% - allow setting initial value rather than taking it from v(1)

  props = defaultValue('props', struct);
  id = defaultValue('id', 'Ca_conc'); % complain if not supplied?

  % for inner function
  props.name = getFieldDefault(props, 'name', id);
  
  % put a default name, but can be overwritten if object is added to
  % solver by a param_mult object. Then, variable name inside param_mult
  % is used as the name.
  if isempty(props.name), props.name = 'm'; end
  % ca_conc obj
  
  %multiply m by ca concentration factor; remove h w/ param_func_nil(1)
%   IKCa = ...
%     param_I_int_v([3 1 5e-03 -80], mKCa, param_func_nil(1), 'I_{KCa}');
%   --> params have to be set in whatever I copy from param_I_int_v.m

  ca_conc = ...
      param_func(...
       {'time [ms]', 'Ca_conc mM'}, ...
       [tauCa, ratio_sa_vol, resting],...
       {'tauCa', 'ratio_sa_vol', 'resting'},...
       @(p, x) feval(eval(deriv_func(ICa.f, getFieldDefault(x, 's', []))), p, x),...
       'dCadt', struct('isIntable', 1,...
       'init_val_func', @(s, v) resting));
   
  props = mergeStructs(props, ...
                       struct('paramRanges', ...
                              [0 4; 0 4; 0 1e3; -100 100]')); %, ...
                              %struct('params', [3 1 5e-03 -80]));
  param_vals = [3 10e-03 -80]; % 5e-03 for gmax
  a_pf = ... % supposed to be total current here
    param_mult(...
      {'time [ms]', 'current [nA]'}, ...
      [param_vals], {'p','gmax', 'E'}, ... % IKCa params
      struct('m', mKCa, 'Ca_conc', ca_conc, 'ICa', ICa), ...
      @I_int, id, props);
  % need to have two param_vals? so one for IKCa and one for ICa?... but
  % does ICa get passed or calculated..??

       % copy over stuff from param_I_int_v.m -> in there, calculate total
       % current and IKCa and ICa (w/ ca_conc implicit)
%   a_pf = ...
%       param_mult(...
%         {'time [ms]', 'activation'}, ...
%         [], {}, ...
%         struct('mKCa', mKCa, ... % sub param_func objects (could be param_mult) - replace w/ ICa and IKCa
%                'Ikca', IKCa), ... % p contains parameters
%         @(fs, p, x) feval(eval(deriv_func(fs, getFieldDefault(x, 's', []))), p, x), id, ...
%         mergeStructs(props, struct('isIntable', 1, ...
%                                    'fHandle', @deriv_func, ...
%                                    'init_val_func', ...
%                                    @(fs, v) f(fs.inf, v))));
%   
% TODO: this should be an object of deriv_func, which should be a
% subclass of param_mult, where the f function is overloaded to do the
% integration.

%ca_conc 
% function dCadt = ca_conc(tau, sa_vol, rest)
%     dCadt = ... % how to get Vm? how to get [Ca]?
%         (-sa_vol*(I_Ca.m^3*I_Ca.h*I_Ca.gmax.data*(Vm-30))-Ca+rest)/tau;
%   
% end 
function dval = act_func_deriv(fs, p, x)
  error('This function doesn''t exist anymore!');
end

function dfunc_str = deriv_func(fs, s) % s = solver_int obj
  %fs_props = get(fs.this, 'props');
  fs_props = mergeStructs(get(fs.m, 'props'), get(fs.h, 'props'));
  if isfield(fs_props, 'VmName')
    % this can be made faster if getVal is not used
    v_str = [ 'getVal(x.s, ''' fs_props.VmName ''')' ];
  else
    v_str = 'x.v';
  end
  %props = get(fs.this, 'props');
  props = mergeStructs(get(fs.m, 'props'), get(fs.h, 'props'));
  if isempty(s) % if the solver_int object is already initiated (already has parent)
    % return function that initiates integration; first round to initalize
    % integration
    dfunc_str = [ '@(p, x) squeeze(integrate(fs.this, x, props))' ];
  else %otherwise start integration; second round, after if statement has run, comes back
    % return derivative (fs binds to the instance here)
    % watch for errors in parentheses here!!
    
    dfunc_str = [ '@(p, x) (  (-p.ratio_sa_vol*(getVal(x.s, ''m'')^3*getVal(x.s, ''h'')*x.s.props.baseFuncs.this.Vm.I.ICa.gmax.data' ...
        '*(getVal(x.s, ''Vm'')-x.s.props.baseFuncs.this.Vm.I.ICa.E.data)) - getVal(x.s, ''Ca_conc'')+p.resting) / p.tauCa )']; %tauCa, ratio_sa_vol, resting
%           x.s.props.baseFuncs -> see below in the I func (it has access
%           to our solver int obj, s, which then has props- one of those
%           props is baseFuncs, which holds all of our functions (as we can
%           see in a_pf - we pass ICa, etc. in as funcs
% dfunc_str = [ '@(p, x) (  (f(fs.inf, ' v_str ') * getVal(x.s,
%     ''Ca_conc'')/(getVal(x.s, ''Ca_conc'')+p.shift))' ... for VM: f(fs.Vm, '
%     v_str ')? getVal(x.s, ''Vm'')?
%         '- getVal(x.s, ''' props.name ''')) ./ ' ...
%                   'f(fs.tau, ' v_str ')']; % mKCa (multiply by calcium conc, insert that in) - shift = 3 (Ca_conc/(Ca_conc+3))
  end
end


  
  function I = I_int (fs, p, x)
    s = getFieldDefault(x, 's', []);
    v = x.v;
    t = getFieldDefault(x, 't', 0);
    dt = x.dt;
    if isempty(s)
      s = solver_int({}, dt, [ 'solver for ' id ], struct('baseFuncs', fs)  );
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
      mCa = getVal(s, 'm');
      m_KCa = getVal(s, 'mKCa');
      if isfield(s.vars, 'h')
        hCa = getVal(s, 'h');
      else
        hCa = 1;
      end
      fs_props = get(a_pf, 'props');
      if isfield(fs_props, 'VmName')
        v = getVal(x.s, fs_props.VmName);
      end
    end
   
    %display(fs.ICa);
    I = (fs.this.ICa.gmax.data * ...
        mCa .^ fs.this.ICa.p.data .* ...
        hCa .^ fs.this.ICa.q.data .* ...
        (v - fs.this.ICa.E.data)) + ...
        p.gmax * ...
        m_KCa .^ p.p .*...
        (v - p.E);
        
        
    %f(fs.ICa, x);

end

end
