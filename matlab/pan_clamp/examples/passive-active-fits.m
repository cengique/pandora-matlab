%% Example script for fitting passive and active properties from
%% voltage clamp data


%% load a file

a_vc = abf2voltage_clamp('test.abf', ' - calcium', struct('ichan', ':'));

% plot to see it
plot(a_vc)

% limit to some steps
vc_select = setLevels(a_vc, 6:14);
plot(vc_select)

% Choose one VC passive step to estimate passive parameters
vc_pas = setLevels(a_vc, 1); 
plot(vc_pas)


%% Plot all traces
plotFigure(plot_abstract(a_vc, '', ...
                         struct('fixedSize', [4 4], 'relativeSizes', [3 1], ...
                                'noTitle', 1, 'xTicksPos', 'bottom', ...
                                'axisLimits', [20 190 NaN NaN])))
% manually zoom to voltage levels and print
print -depsc2 traces_vc_full.eps

% plot select
plotFigure(plot_abstract(vc_select, '', ...
                         struct('fixedSize', [4 4], 'relativeSizes', [2 1], ...
                                'noTitle', 1, 'xTicksPos', 'bottom', ...
                                'axisLimits', [20 190 NaN NaN])))
print -depsc2 traces_select.eps

%% fit passive properties

plot(vc_pas) 

% Use the ready-made passive fitter
[pasresults pas_md pas_doc] = ...
    getResultsPassiveReCeElec(data_L1_passive(vc_pas), ...
                              struct('stepNum', 2, ...
                                     'minRe', 5, ...
                                     'delay', 0));
% => should give:
% $$$ resnorm: 0.012065, ssenorm: 0.00029174
% $$$     'Param'        'Value'      'Diff'           '95% rel. conf.' 
% $$$     'Vm_Re'        [43.8739]    [    -0.5416]    '+/- 3.05569'    
% $$$     'Vm_Ce'        [ 0.0011]    [-6.3941e-05]    '+/- 0.000135602'
% $$$     'Vm_Cm'        [ 0.0187]    [-5.6168e-04]    '+/- 0.000531843'
% $$$     'Vm_offset'    [ 0.0460]    [    -0.0044]    '+/- 0.00240014' 

% and with units:
% $$$ pasresults = 
% $$$ 
% $$$         fit_Ce_pF: 1.1138
% $$$         fit_Cm_pF: 18.7434
% $$$         fit_EL_mV: -61.5576
% $$$         fit_Re_MO: 43.8739
% $$$      fit_delay_ms: 0.1002
% $$$         fit_gL_nS: 0.0786
% $$$     fit_offset_pA: 46.0206

% pas_md holds the model-data combo object
struct(pas_md)

% the model
pas_md.model_f

% VC data
pas_md.data_vc

%% Add an ion channel to the md object

% Draft of Na chan
m_Na = param_act_deriv_ab_v(struct('V_half', -30, 'tau0', 1, ...
                                   'k', -4, 'delta', 0.8), 'm', ...
                            struct('VmName', 'Vm'));
h_Na = param_act_deriv_ab_v(struct('V_half', -80, 'tau0', 3, ...
                                   'k', 4, 'delta', 0.8), 'h', ...
                            struct('VmName', 'Vm'));
I_v = ...
    param_I_int_v([3 1 1e-3 60], m_Na, h_Na, 'I_{Na}', ...
                  struct('VmName', 'Vm'));
% => made sure m,h,I are getting Vm

% plot them
plot(m_Na.props.inf_func(m_Na))
plot(h_Na.props.inf_func(h_Na))

% Add the current into the passive model
Na_md = pas_md;
Na_md.model_f.Vm.I = I_v;

% add the active steps data
Na_md.data_vc = vc_select;

% simulate model once with new steps
Na_md = ...
    updateModel(Na_md, []);
% Passing struct('updateVm', 1) will update the model_vc with the
% model series resistance effects

% plot comparison of data vs model
plot(Na_md)

%% Start fitting active channel

% freeze passive model and only let Na chan params to change

% start with only gmax & E
Na_Rs_comp_actNa4_fit_md = Na_Rs_comp_actNa4_md;
Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw = ...
    setProp(Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw, 'selectParams', {});
Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I = ...
    setProp(Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I, ...
            'selectParams', {'gmax', 'E'});
Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I.m = ...
    setProp(Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I.m, ...
            'selectParams', {});
Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I.h = ...
    setProp(Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I.h, ...
            'selectParams', {});
% check
getParamsStruct(Na_Rs_comp_actNa4_fit_md.model_f, ...
                struct('onlySelect', 1))

Na_Rs_comp_actNa4_fit_md = ...
    fit(Na_Rs_comp_actNa4_fit_md, '', ...        
        struct('dispParams', 5, 'dispPlot', 1, 'fitRangeRel', [13 -50 20], ...
               'outRangeRel', [13 -.3 3], ...
               'saveModelFile', [ 'Na-model-fit-%d.mat'], ...
               'saveModelAutoNum', 1, ...
               'savePlotFile', ...
               [ 'doc/plot-Na-fit-try1.eps'], ...
               'optimset', struct('Display', 'iter')))
% => found meaningful gmax & E!
% $$$ resnorm: 5534.325, ssenorm: 0.013092
% $$$     'Param'           'Value'      'Diff'        '95% rel. conf.'
% $$$     'Vm_Vw_I_gmax'    [ 5.5169]    [  5.5159]    '+/- 0.130019'  
% $$$     'Vm_Vw_I_E'       [49.5157]    [-10.4843]    '+/- 2.56712'   

%% switch to parfor and fit all params?

% does not work because of the nature of the derivative function
% implementations :(
Na_Rs_comp_actNa4_fit_md.model_f = ...
    setProp(Na_Rs_comp_actNa4_fit_md.model_f, 'parfor', 1);

% delete it
Na_Rs_comp_actNa4_fit_md.model_f.props = ...
    rmfield(Na_Rs_comp_actNa4_fit_md.model_f.props, 'parfor');

% release all m & h parameters
Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I.m = ...
    setProp(Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I.m, ...
            'selectParams', {'/.*/'});
Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I.h = ...
    setProp(Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I.h, ...
            'selectParams', {'/.*/'});
% check
getParamsStruct(Na_Rs_comp_actNa4_fit_md.model_f, ...
                struct('onlySelect', 1))

% run it
Na_Rs_comp_actNa4_fit_md = ...
    fit(Na_Rs_comp_actNa4_fit_md, '', ...        
        struct('dispParams', 5, 'dispPlot', 1, 'fitRangeRel', [13 -50 20], ...
               'outRangeRel', [13 -.3 3], ...
               'saveModelFile', [ 'Na-model-fit-%d.mat'], ...
               'saveModelAutoNum', 1, ...
               'savePlotFile', ...
               [ 'doc/plot-Na-fit-all-params-try1.eps'], ...
               'optimset', struct('Display', 'iter')))
% 1st run => some changes, but then got stuck:
% $$$ resnorm: 5337.6515, ssenorm: 0.012627
% $$$     'Param'              'Value'         'Diff'          '95% rel. conf.' 
% $$$     'Vm_Vw_I_gmax'       [    5.5401]    [    0.0231]    '+/- 0.0679433'  
% $$$     'Vm_Vw_I_E'          [   50.7742]    [    1.2585]    '+/- 0.357165'   
% $$$     'Vm_Vw_I_m_a0'       [  402.2637]    [   -1.1651]    '+/- 5.53081'    
% $$$     'Vm_Vw_I_m_b0'       [    0.2304]    [    0.0073]    '+/- 0.0163091'  
% $$$     'Vm_Vw_I_m_delta'    [    0.7886]    [   -0.0114]    '+/- 0.0206367'  
% $$$     'Vm_Vw_I_m_k'        [   -4.0386]    [   -0.0386]    '+/- 0.0465607'  
% $$$     'Vm_Vw_I_h_a0'       [5.1897e-07]    [4.8145e-07]    '+/- 1.67352e-08'
% $$$     'Vm_Vw_I_h_b0'       [   17.7176]    [   -0.4817]    '+/- 0.383639'   
% $$$     'Vm_Vw_I_h_delta'    [    0.8167]    [    0.0167]    '+/- 2.14671e-08'
% $$$     'Vm_Vw_I_h_k'        [    3.8853]    [   -0.1147]    '+/- 0.00015446' 

% run it a 2nd time:
resnorm: 5303.3336, ssenorm: 0.012546
% $$$     'Param'              'Value'         'Diff'           '95% rel. conf.' 
% $$$     'Vm_Vw_I_gmax'       [    5.5411]    [     0.0011]    '+/- 0.793072'   
% $$$     'Vm_Vw_I_E'          [   50.7683]    [    -0.0059]    '+/- 6.61602'    
% $$$     'Vm_Vw_I_m_a0'       [  402.4195]    [     0.1559]    '+/- 52.8805'    
% $$$     'Vm_Vw_I_m_b0'       [    0.2306]    [ 2.4903e-04]    '+/- 0.182466'   
% $$$     'Vm_Vw_I_m_delta'    [    0.7892]    [ 6.0035e-04]    '+/- 0.0657698'  
% $$$     'Vm_Vw_I_m_k'        [   -4.0385]    [ 4.7156e-05]    '+/- 0.290435'   
% $$$     'Vm_Vw_I_h_a0'       [5.0811e-07]    [-1.0856e-08]    '+/- 9.08174e-09'
% $$$     'Vm_Vw_I_h_b0'       [   17.7068]    [    -0.0109]    '+/- 1.44328'    
% $$$     'Vm_Vw_I_h_delta'    [    0.8167]    [ 3.3403e-09]    '+/- 0.00128147' 
% $$$     'Vm_Vw_I_h_k'        [    3.8853]    [ 3.4118e-05]    '+/- 0.0059453'  

% => no change

% try parfor

% release only m
Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I.m = ...
    setProp(Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I.m, ...
            'selectParams', {'/.*/'});
% check
getParamsStruct(Na_Rs_comp_actNa4_fit_md.model_f, ...
                struct('onlySelect', 1))

% run it
Na_Rs_comp_actNa4_fit_md = ...
    fit(Na_Rs_comp_actNa4_fit_md, '', ...        
        struct('dispParams', 5, 'dispPlot', 1, 'fitRangeRel', [13 -50 20], ...
               'outRangeRel', [13 -.3 3], ...
               'saveModelFile', [ 'Na-model-fit-%d.mat'], ...
               'saveModelAutoNum', 1, ...
               'savePlotFile', ...
               [ 'doc/plot-Na-fit-all-params-try1-only-m.eps'], ...
               'optimset', struct('Display', 'iter')))
% => worked -30 step is matched, but it's a bit fat

% $$$ resnorm: 5169.9436, ssenorm: 0.01223
% $$$     'Param'              'Value'       'Diff'       '95% rel. conf.'
% $$$     'Vm_Vw_I_gmax'       [  4.3782]    [-1.1387]    '+/- 1.93417'   
% $$$     'Vm_Vw_I_E'          [ 54.3946]    [ 4.8789]    '+/- 19.2524'   
% $$$     'Vm_Vw_I_m_a0'       [405.0844]    [ 1.6556]    '+/- 124.655'   
% $$$     'Vm_Vw_I_m_b0'       [  0.0086]    [-0.2146]    '+/- 0.196415'  
% $$$     'Vm_Vw_I_m_delta'    [  0.8962]    [ 0.0962]    '+/- 0.285414'  
% $$$     'Vm_Vw_I_m_k'        [ -5.2572]    [-1.2572]    '+/- 1.4721'    

% run both m & h

% m & h
Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I.h = ...
    setProp(Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I.h, ...
            'selectParams', {'/.*/'});
% check
getParamsStruct(Na_Rs_comp_actNa4_fit_md.model_f, ...
                struct('onlySelect', 1))
% run it
Na_Rs_comp_actNa4_fit_md = ...
    fit(Na_Rs_comp_actNa4_fit_md, '', ...        
        struct('dispParams', 5, 'dispPlot', 1, 'fitRangeRel', [13 -50 20], ...
               'outRangeRel', [13 -.3 3], ...
               'saveModelFile', [ 'Na-model-fit-%d.mat'], ...
               'saveModelAutoNum', 1, ...
               'savePlotFile', ...
               [ 'doc/plot-Na-fit-all-params-try2-m+h.eps'], ...
               'optimset', struct('Display', 'iter')))
% => -30 mV step a bit messed up 

%% also fit the inactivation time step & and add 1-2 inact steps

Na_Rs_comp_actNa4_fit_md.data_vc = vc_Rs_actNa4_inact;

% only h
Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I.m = ...
    setProp(Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I.m, ...
            'selectParams', {});
% check
getParamsStruct(Na_Rs_comp_actNa4_fit_md.model_f, ...
                struct('onlySelect', 1))

% run it
Na_Rs_comp_actNa4_fit_md = ...
    fit(Na_Rs_comp_actNa4_fit_md, '', ...        
        struct('dispParams', 5, 'dispPlot', 1, 'fitRangeRel', [13 -50 20], ...
               'outRangeRel', [13 -2 -1; 13 .2 3; 13 8 9; 14 .2 8], ...
               'saveModelFile', [ 'Na-model-fit-%d.mat'], ...
               'saveModelAutoNum', 1, ...
               'savePlotFile', ...
               [ 'doc/plot-Na-fit-all-params-try3-h-inact-traces.eps'], ...
               'optimset', struct('Display', 'iter')))
% => no change, failed.

% retry with m added
% => also failed.

% manually push h to the left? 
Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I.h = ...
    param_act_deriv_ab_v(struct('V_half', -90, 'tau0', 60, ...
                                'k', 4, 'delta', 0.8), 'h', ...
                         struct('VmName', 'Vm'));
% => there was improvement for tau0=7, so make it larger

% update & plot for manual fit
Na_Rs_comp_actNa4_fit_md = ...
    updateModel(Na_Rs_comp_actNa4_fit_md, []);
plotFigure(plot_abstract(Na_Rs_comp_actNa4_fit_md, '', ...
                         struct('skipStep', 11)))

% try fitting for h_tau0 = 60
% => almost no change, fail

% only change m
Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I = ...
    setProp(Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I, ...
            'selectParams', {});
Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I.h = ...
    setProp(Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I.h, ...
            'selectParams', {});
getParamsStruct(Na_Rs_comp_actNa4_fit_md.model_f, ...
                struct('onlySelect', 1))
% => exactly 0 change :(

% try with h only (no gmax & E)
% => integration error

% run w/o steady range, m & h only
Na_Rs_comp_actNa4_fit_md = ...
    fit(Na_Rs_comp_actNa4_fit_md, '', ...        
        struct('dispParams', 5, 'dispPlot', 1, 'fitRangeRel', [13 -5 16], ...
               'outRangeRel', [13 -1.2 -1; 13 .2 6; 14 .2 5], ...
               'saveModelFile', [ 'Na-model-fit-%d.mat'], ...
               'saveModelAutoNum', 1, ...
               'savePlotFile', ...
               [ 'doc/plot-Na-fit-all-params-try3-h-inact-no-steady.eps'], ...
               'optimset', struct('Display', 'iter')))
% => there's change, but stuck soon after. Saved as Na-model-fit-9.mat

% $$$ resnorm: 25951.5712, ssenorm: 0.0090759
% $$$     'Param'              'Value'         'Diff'           '95% rel. conf.' 
% $$$     'Vm_Vw_I_m_a0'       [  407.4594]    [     0.0063]    '+/- 0.00017045' 
% $$$     'Vm_Vw_I_m_b0'       [    0.0077]    [-1.2998e-05]    '+/- 3.68136e-07'
% $$$     'Vm_Vw_I_m_delta'    [    0.9041]    [-1.2468e-06]    '+/- 6.23223e-07'
% $$$     'Vm_Vw_I_m_k'        [   -5.3074]    [ 5.2702e-06]    '+/- 2.00291e-06'
% $$$     'Vm_Vw_I_h_a0'       [1.1497e-08]    [ 1.1137e-08]    '+/- 8.50176e-09'
% $$$     'Vm_Vw_I_h_b0'       [    1.5003]    [-4.4023e-07]    '+/- 1.15496e-07'
% $$$     'Vm_Vw_I_h_delta'    [    0.8000]    [-1.4286e-06]    '+/- 4.01808e-07'
% $$$     'Vm_Vw_I_h_k'        [    4.0000]    [ 4.9395e-06]    '+/- 1.9394e-06' 

% => there's a large change in the h.a0 param, however, that messes
% up inactivation period -70 mV step results. Also -50 mV step is
% activated although it shouldn't.

% add gmax & E and try again
% => failed integration twice

% try w/o them

% => UHH, paramRanges were missing in param_act_deriv_ab_v!
param_ranges = ...
    [ eps  eps  0 -1e3;...
      1e20 1e20 1  1e3];
Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I.m = ...
    setProp(Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I.m, ...
            'paramRanges', [param_ranges]);
Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I.h = ...
    setProp(Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I.h, ...
            'paramRanges', [param_ranges]);

% add gmax & E and try again
% $$$ resnorm: 49859.3912, ssenorm: 0.0089914
% $$$     'Param'              'Value'         'Diff'           '95% rel. conf.' 
% $$$     'Vm_Vw_I_gmax'       [    4.3606]    [-8.1933e-06]    '+/- 9.09788e-06'
% $$$     'Vm_Vw_I_E'          [   54.3841]    [    -0.0013]    '+/- 0.000132488'
% $$$     'Vm_Vw_I_m_a0'       [  407.4599]    [ 5.4285e-04]    '+/- 0.0014696'  
% $$$     'Vm_Vw_I_m_b0'       [    0.0077]    [ 1.3781e-05]    '+/- 3.93742e-06'
% $$$     'Vm_Vw_I_m_delta'    [    0.9041]    [-4.0459e-06]    '+/- 1.61206e-06'
% $$$     'Vm_Vw_I_m_k'        [   -5.3074]    [ 3.0902e-06]    '+/- 6.67449e-06'
% $$$     'Vm_Vw_I_h_a0'       [1.4114e-09]    [-1.0086e-08]    '+/- 5.28355e-09'
% $$$     'Vm_Vw_I_h_b0'       [    1.5003]    [-7.4332e-09]    '+/- 2.29545e-06'
% $$$     'Vm_Vw_I_h_delta'    [    0.8000]    [ 1.4016e-05]    '+/- 2.02298e-06'
% $$$     'Vm_Vw_I_h_k'        [    4.0000]    [-4.2804e-06]    '+/- 1.30946e-05'
% $$$ Saved as Na-model-fit-9.mat
% => slight improvement, but major problems persist.

% change only m
% $$$ resnorm: 49844.6823, ssenorm: 0.0089887
% $$$     'Param'              'Value'       'Diff'           '95% rel. conf.' 
% $$$     'Vm_Vw_I_m_a0'       [407.4603]    [ 4.0755e-04]    '+/- 0.00123241' 
% $$$     'Vm_Vw_I_m_b0'       [  0.0077]    [-2.2822e-06]    '+/- 1.01617e-07'
% $$$     'Vm_Vw_I_m_delta'    [  0.9041]    [ 2.5415e-07]    '+/- 1.56816e-07'
% $$$     'Vm_Vw_I_m_k'        [ -5.3074]    [-6.5157e-06]    '+/- 3.04674e-06'
% minor improvement => saved as #14

% fit everything w/ m +5 mV shift
% => 0 change, completely stuck

% manual tools
get_tau0 = @(p) 1/(p.a0^(1-p.delta)* p.b0^(p.delta));
get_V_half = @(p) -p.k*log(p.b0/p.a0);

get_alt_params = @(p) struct('tau0', 1/(p.a0^(1-p.delta)* ...
                                        p.b0^(p.delta)), ...
                             'delta', p.delta, ...
                             'V_half', -p.k*log(p.b0/p.a0), ...
                             'k', p.k);
get_alt_params(getParamsStruct(Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I.m))
get_alt_params(getParamsStruct(Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I.h))

% manually push m to the right? +5 mV
Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I.m = ...
    param_act_deriv_ab_v(struct('V_half', -30, 'tau0', 0.3, ...
                                'k', -5.3, 'delta', 0.99), 'm', ...
                         struct('VmName', 'Vm'));
% push h to the left
Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I.h = ...
    param_act_deriv_ab_v(struct('V_half', -90, 'tau0', 2, ...
                                'k', 4, 'delta', 0.87), 'h', ...
                         struct('VmName', 'Vm'));
% modify I params
Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.I.gmax.data = 4.3;

% modify Vm_Vw params
Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.pred.data = 90;
Na_Rs_comp_actNa4_fit_md.model_f.Vm_Vw.corr.data = 83;

% update & plot for manual fit
Na_Rs_comp_actNa4_fit_md = ...
    updateModel(Na_Rs_comp_actNa4_fit_md, [], ...
                struct('updateVm', 1)); % need to see it
plotFigure(plot_abstract(Na_Rs_comp_actNa4_fit_md, '', ...
                         struct('skipStep', 11, ...
                                'axisLimits', [890.2 891.6 NaN NaN], ...
                                'iLimits', [-11 1], ...
                                'vLimits', [-35 10])))

% try plotting all the steps
Na_Rs_comp_actNa4_fit_md.data_vc = setLevels(vc_Rs, [8:17]);

% print one
print -depsc2 doc/plot-Na-Rs-comp-manual-fit-act-steps-detailed-view.eps

% doing progress!
% $$$ m:
% $$$       tau0: 13
% $$$      delta: 0.9500
% $$$     V_half: -45
% $$$          k: -5.3000
% $$$ h:
% $$$       tau0: 13.0000
% $$$      delta: 0.7700
% $$$     V_half: -90
% $$$          k: 4
% => peaks aligned and looks quite close! except -5 and +10 mV
% peaks too small

% $$$ m:
% $$$       tau0: 10
% $$$      delta: 0.9600
% $$$     V_half: -45
% $$$          k: -5.3000
% $$$ h:
% $$$       tau0: 10.0000
% $$$      delta: 0.8200
% $$$     V_half: -90
% $$$          k: 4
% => +10 mV and -5 mV matched perfectly, but -20 and -30 a bit too
% large

% $$$ m: 
% $$$       tau0: 0.3000
% $$$      delta: 0.9900
% $$$     V_half: -25
% $$$          k: -5.3000
% $$$ h:
% $$$       tau0: 4.0000
% $$$      delta: 0.8500
% $$$     V_half: -90
% $$$          k: 4 
% => m half-act may be too high now. bring it back 5 mV at least.

% $$$ I:
% $$$ 	    pred: 90%
% $$$ 	    corr: 83%
% $$$ m:
% $$$       tau0: 0.3000
% $$$      delta: 0.9900
% $$$     V_half: -30.0000
% $$$          k: -5.3000
% $$$ h:
% $$$       tau0: 2.0000
% $$$      delta: 0.8700
% $$$     V_half: -90
% $$$          k: 4
% => good enough although cannot fit squished steps
print -depsc2 doc/plot-Na-Rs-comp-manual-fit-close-enough.eps

% => the data is too weird to fit. Stop here and switch to new
% data. Latest params are in the functions above.

 % TODO:
