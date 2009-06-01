
% example: create a logsig param_func for an activation variable
a_ps = param_func({'voltage [mV]', 'activation'}, [-50 10], {'V_half', 'k'}, ...
                 @(p,x) deal(1./(1 + exp((x-p(1)) ./ p(2))), NaN), ...
                 'inactivation', ...
                 struct('xMin', -100, 'xMax', 100))

% more direct way of creating act/inact curves
a_pa = param_act([-50 10], 'inactivation')

% TODO: 
% - create subclass for defining logsig functions easily
% - override plot commands
% - implement ranges
% - make ui to change params and ranges
% - embed uis from a master object