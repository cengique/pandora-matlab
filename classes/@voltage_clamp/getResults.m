function a_prof = getResults(a_vc, props)

% getResults - Calculate measurements and observations from this object.
%
% Usage:
% a_prof = getResults(a_vc, props)
%
% Parameters:
%   a_vc: A voltage_clamp object.
%   props: A structure with any optional properties (inherited from a_vc).
%     skipStep: Number of voltage step times to skip at the start (default=0).
%		
% Returns:
%   a_prof: A params_results_profile object with parameters and results structures.
%
% Description:
%
% Example:
% >> a_cs = params_tests_dataset({md1, md2})
% >> a_db = params_tests_db(a_cs) % calls loadItemProfile, which calls getResults
%
% See also: params_tests_dataset/loadItemProfile, params_tests_dataset
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/07/08

% TODO: return a_doc with some figures

props = mergeStructs(defaultValue('props', struct), get(a_vc, 'props'));

skip_step = getFieldDefault(props, 'skipStep', 0);

% no params?
params = struct; 

% add peak current, persistent component, etc.
act_vc = ...
    calcCurPeaks(a_vc, 2 + skip_step, ...
                 struct('pulseStartRel', [1 + skip_step 1], ...
                        'pulseEndRel', [1 + skip_step 10]));

act_props = get(act_vc, 'props');
[temp peak_nat_v_idx ] = ...
    max(abs(act_props.iPeaks));

results.peakITrans = ...
    act_props.iPeaks(peak_nat_v_idx);
results.peakVTrans = ...
    act_vc.v_steps(2 + skip_step, peak_nat_v_idx);

% find observed V_half from I-V curve
halfITrans = results.peakITrans / 2;
half_act_idx = ...
    find(act_props.iPeaks(1:peak_nat_v_idx) < halfITrans);

% watch out for shadowing argument 
interp_f = @(x, a_vc, vc_props) ...
    a_vc.v_steps(2 + skip_step, x - 1) + ...
    diff(a_vc.v_steps(2 + skip_step, x + [-1 0])) * ...
    (halfITrans - vc_props.iPeaks(x - 1)) / ...
    diff(vc_props.iPeaks(x + [-1 0]));


% interpolate to find the precise voltage
results.actVhalfobs = interp_f(half_act_idx(1), act_vc, act_props);

% find observed inactivation Vhalf
inact_vc = ...
    calcCurPeaks(a_vc, 3 + skip_step, ...
                 struct('pulseStartRel', [2 + skip_step .1], ...
                        'pulseEndRel', [2 + skip_step 10]));
inact_props = get(inact_vc, 'props');

half_inact_idx = ...
    find(inact_props.iPeaks(1:peak_nat_v_idx) > halfITrans);

results.inactVhalfobs = ...
    interp_f(half_inact_idx(1), inact_vc, inact_props);

% persistent current (Pers)
step_range = a_vc.time_steps(2 + skip_step) + ...
    round([-15 -5] / get(a_vc, 'dt') / 1e3);
i_steps = ...
    mean(a_vc.i.data(step_range(1):step_range(2), :));
[temp peak_nap_v_idx] = max(abs(i_steps));

results.peakIPers = ...
    i_steps(peak_nap_v_idx);

results.peakVPers = ...
    a_vc.v_steps(2 + skip_step, peak_nap_v_idx);

% value of Pers at peak voltage of Trans
results.peakIPersAtPeakVTrans = ...
    i_steps(peak_nat_v_idx);

% Pers/Trans ratios
results.ratioIPersTrans = ...
    abs(results.peakIPers / results.peakITrans);

results.ratioIPersTransAtPeakVTrans = ...
    abs(results.peakIPersAtPeakVTrans / results.peakITrans);

% return profile with params and results
a_prof = ...
    params_results_profile(params, results, ...
                           [ get(a_vc, 'id')], ...
                           props);