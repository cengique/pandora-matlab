function data_L1_passive_test
  
% data_L1_passive_test - Unit test for @param_act.
%
% Usage:
%   data_L1_passive_test
%
% Parameters:
%		
% Returns:
%
% Description:  
%   Uses the xunit framework by Steve Eddins downloaded from Mathworks
% File Exchange.
%
% See also: xunit
%
% $Id: data_L1_passive_test.m 168 2010-10-04 19:02:23Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/01/21

% orig params
orig_params_noRe = ...
    struct('gL', .005, 'EL', -80, 'Cm', 0.040, 'delay', .7, 'offset', 0.050);

orig_params = mergeStructs(struct('Re', 10, 'Ce', 0.001), orig_params_noRe);

% for surrogate data, make models
a_cap_model = ...
    param_cap_leak_int_t(orig_params_noRe, ['cap, leak']);

% a param_Re_Ce_cap_leak_act_int_t object and simulate it
a_ReCe_model = ...
    param_Re_Ce_cap_leak_int_t(orig_params, ...
                               ['cap, leak, Re, Ce']);

dt = .1; % [ms]
end_ms = 200;

% make a fake voltage step
ideal_v = ...
    makeIdealClampV([10 100 end_ms], -90, -70, 20, dt, 'test step');

% make an empty current trace
response_i = trace(zeros(end_ms/dt*1e3, 1), dt*1e-3, 1e-9, 'model output');

% make a voltage_clamp object and simulate the model
model_vc = voltage_clamp(response_i.data, ideal_v.data, dt*1e-3, 1e-9, ...
                         1e-3, 'test model ideal clamp');
model_vc = simModel(model_vc, a_cap_model);

% make a data_L1_passive object
a_pas = data_L1_passive(model_vc, 'test');

% tests
assertElementsAlmostEqual(orig_params.delay, calcDelay(a_pas), ...
                          'absolute', .3);

[gL, EL, offset] = calcSteadyLeak(a_pas);
assertElementsAlmostEqual([orig_params.gL orig_params.EL orig_params.offset], ...
                          [gL, EL, offset], 'absolute', eps(1));

% switch to Re model
model_vc = simModel(model_vc, a_ReCe_model);
a_pas = data_L1_passive(model_vc, 'test');

% no props, re-calculates everything
[Re Cm] = calcReCm(a_pas);

% rough estimate
assertElementsAlmostEqual(orig_params.Re, Re, 'absolute', 10) % MOhm tolerance
assertElementsAlmostEqual(orig_params.Cm, Cm, 'absolute', .005); % pF tolerance

% run full fit
new_params = getResultsPassiveReCeElec(a_pas, struct('minRe', 1))

% compare percent change (<20%)
assertElementsAlmostEqual(...
  [orig_params.Re orig_params.Ce orig_params.Cm orig_params.gL orig_params.EL ...
   orig_params.delay orig_params.offset], ...
  [new_params.Vm_Re new_params.Vm_Ce new_params.Vm_Cm new_params.Vm_gL new_params.Vm_EL ...
   new_params.Vm_delay new_params.Vm_offset], 'relative', .2, 0);

