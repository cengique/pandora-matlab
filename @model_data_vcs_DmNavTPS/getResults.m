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
model_results = get(getResults(get(a_md, 'model_vc'), props), 'results');

% merge while suffixing with 'Model'
results = ...
    mergeStructs(results, ...
                 cell2struct(struct2cell(model_results), ...
                             cellfun(@(x) [x 'Model'], fieldnames(model_results), ...
                                     'UniformOutput', false)));

pow_corr_f = @(a_f, gate, pow) ...
    a_f.(gate).inf.V_half.data + ...
    a_f.(gate).inf.k.data * log(1/(.5^(1/ a_f.(pow).data))-1);

results.nat_m_inf_V_half_corr = pow_corr_f(model_f.nat, 'm', 'p');
results.peakITransGmaxModel = results.peakITransModel / results.nat_gmax;
results.ratioGmaxPersTransModel = ...
    results.nap_gmax / results.nat_gmax;

% do the same for estimation from data
data_results = get(getResults(get(a_md, 'data_vc'), props), 'results');

% merge while suffixing with 'Data'
results = ...
    mergeStructs(results, ...
             cell2struct(struct2cell(data_results), ...
                cellfun(@(x) [x 'Data'], fieldnames(data_results), ...
                        'UniformOutput', false)));


% return profile with params and results
a_prof = ...
    params_results_profile(params, results, ...
                           [ get(a_md, 'name') ': ' get(a_md, 'id')], ...
                           props);