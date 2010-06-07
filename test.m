

% example: create a logsig param_func for an activation variable
a_ps = param_func({'voltage [mV]', 'activation'}, [-50 10], {'V_half', 'k'}, ...
                 @(p,x) 1./(1 + exp((x-p(1)) ./ p(2))), ...
                 'inactivation', ...
                 struct('xMin', -100, 'xMax', 100))

% more direct way of creating act/inact curves
a_pa = param_act([-1 1], 'inactivation')
plot(a_pa)

% this time define ranges, so parameter values become ratios
a_pi = param_act([-50 10], 'inactivation', ...
                 struct('paramRanges', ...
                        [-80 0; 1 30]'))

getParams(a_pi, struct('direct', 1))
getParams(a_pi)
a_pi = setParams(a_pi, [0.7 0.5], struct('direct', 1))

% this is an activation gate
a_pa = param_act([-30 -10], 'activation', ...
                 struct('paramRanges', ...
                        [-70 0; -30 -1]'))

% V-dep tau curve
a_p_tau_v = param_tau_v([ 0.9450    1.8440  -14.8100   12.3900], 'tau')

% create an activation variable dependent on time
a_act_t = param_act_t(-90, 20, a_pa, a_p_tau_v, 'an act. gate');
a_inact_t = param_act_t(-90, 20, a_pi, a_p_tau_v, 'an inact. gate');

% create current
a_cur = ...
    param_I_t([3 1 -80 20 10], a_act_t, a_inact_t, 'act-inact cur');

% try with multiple voltage steps
a_act_t = param_act_t(-90, [20; 30], a_pa, a_p_tau_v, 'an act. gate');
a_inact_t = param_act_t(-90, [20; 30], a_pi, a_p_tau_v, 'an inact. gate');

a_cur = ...
    param_I_t([3 1 10 -80], [20; 30], a_act_t, a_inact_t, 'act-inact cur');


% TODO: 
% - create subclass for defining logsig functions easily
% - override plot commands
% - implement ranges
% - make ui to change params and ranges
% - embed uis from a master object