function a_prof = getResults(a_md, props)

% getResults - Calculate measurements and observations from md object.
%
% Usage:
% a_prof = getResults(a_md, props)
%
% Parameters:
%   a_md: A model_data_vcs_DmNavTPS object.
%   props: A structure with any optional properties (inherited from a_md).
%     skipStep: Number of voltage step times to skip at the start (default=0).
%		
% Returns:
%   a_prof: A params_results_profile object with parameters and results structures.
%
% Description:
%
% Example:
% >> a_cs = cellset_L1({md1, md2})
% >> a_db = params_tests_db(a_cs) % calls loadItemProfile, which calls getResults
%
% See also: model_data_vcs_DmNavTPS, cellset_L1/loadItemProfile, params_tests_dataset
%
% $Id: getResults.m 234 2010-10-21 22:06:52Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/07/05

% TODO: return a_doc with some figures

props = mergeStructs(defaultValue('props', struct), get(a_md, 'props'));

skip_step = getFieldDefault(props, 'skipStep', 0);

params = struct; 
params.DmNav = sscanf(get(a_md, 'name'), 'DmNav%d');

params = mergeStructs(params, props.exons);

% dump all fitted channel parameters
model_f = get(a_md, 'model_f');
results = getParamsStruct(model_f);

% add peak current, persistent component, etc.
model_vc = get(a_md, 'model_vc');
model_vc = ...
    calcCurPeaks(model_vc, 2 + skip_step, ...
                 struct('pulseStartRel', [1 + skip_step 1], ...
                        'pulseEndRel', [1 + skip_step 10]));

[temp peak_nat_v_idx ] = ...
    max(abs(model_vc.props.iPeaks));

results.peakINaT = ...
    model_vc.props.iPeaks(peak_nat_v_idx);
results.peakVNaT = ...
    model_vc.v_steps(2 + skip_step, peak_nat_v_idx);

results.peakINaTgmax = results.peakINaT / results.nat_gmax;

% find observed V_half from I-V curve
halfINaT = results.peakINaT / 2;
half_act_idx = ...
    find(model_vc.props.iPeaks(1:peak_nat_v_idx) < halfINaT);

interp_f = @(x, a_vc) ...
    a_vc.v_steps(2 + skip_step, x - 1) + ...
    diff(a_vc.v_steps(2 + skip_step, x + [-1 0])) * ...
    (halfINaT - a_vc.props.iPeaks(x - 1)) / ...
    diff(a_vc.props.iPeaks(x + [-1 0]));

pow_corr_f = @(a_f, gate, pow) ...
    a_f.(gate).inf.V_half.data + ...
    a_f.(gate).inf.k.data * log(1/(.5^(1/ a_f.(pow).data))-1);

% interpolate to find the precise voltage
results.actVhalfobs = interp_f(half_act_idx(1), model_vc);
results.actVhalfpow = pow_corr_f(model_f.nat, 'm', 'p');

% find observed inactivation Vhalf
model_inact_vc = ...
    calcCurPeaks(model_vc, 3 + skip_step, ...
                 struct('pulseStartRel', [2 + skip_step .1], ...
                        'pulseEndRel', [2 + skip_step 10]));

half_inact_idx = ...
    find(model_inact_vc.props.iPeaks(1:peak_nat_v_idx) > halfINaT);

results.inactVhalfobs = ...
    interp_f(half_inact_idx(1), model_inact_vc);

% persistent current (NaP)
step_range = model_vc.time_steps(2 + skip_step) + ...
    round([-15 -5] / model_vc.dt / 1e3);
i_steps = ...
    mean(model_vc.i.data(step_range(1):step_range(2), :));
[temp peak_nap_v_idx] = max(abs(i_steps));

results.peakINaP = ...
    i_steps(peak_nap_v_idx);

results.peakVNaP = ...
    model_vc.v_steps(2 + skip_step, peak_nap_v_idx);

% value of NaP at peak voltage of NaT
results.peakINaPatPeakVNaT = ...
    i_steps(peak_nat_v_idx);

% NaP/NaT ratios
results.ratioINaPNaT = ...
    abs(results.peakINaP / results.peakINaT);

results.ratioINaPNaTatPeakVNaT = ...
    abs(results.peakINaPatPeakVNaT / results.peakINaT);

results.ratioINaPNaTatPeakVNaTnormGmaxNaT = ...
    results.peakINaPatPeakVNaT / results.peakINaT / results.nat_gmax;

results.ratioGmaxNaPNaT = ...
    results.nap_gmax / results.nat_gmax;

% return profile with params and results
a_prof = ...
    params_results_profile(params, results, ...
                           [ get(a_md, 'name') ': ' get(a_md, 'id')], ...
                           props);