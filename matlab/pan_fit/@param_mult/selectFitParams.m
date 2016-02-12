function a_m = selectFitParams(a_m, param_name_pat, fit_nofit, props)

% selectFitParams - Constrain or release model parameters for fitting.
%
% Usage:
% a_m = selectFitParams(a_m, param_name_pat, fit_nofit, props)
%
% Parameters:
%   a_m: A param_mult object.
%   param_name_pat: Regular expression pattern compared to parameter names.
%   fit_nofit: 1 for including in fits and 0 for not.
%   props: A structure with any optional properties.
%     recursive: Apply same pattern recursively to child objects.
% 
% Returns:
%   a_m: Updated object.
%
% Description:
%
% Example:
% % Sets all parameters recursively
% >> a_m = selectFitParams(a_m, '.*', 1, struct('recursive', 1));
%
% See also: param_func/selectFitParams
%
% $Id: selectFitParams.m 234 2010-10-21 22:06:52Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/05/04

props = defaultValue('props', struct);

if isfield(props, 'recursive')
  fs_names = fieldnames(a_m.f);
  for f_num = 1:length(fs_names)
    a_m.f.(fs_names{f_num}) = ...
      selectFitParams(a_m.f.(fs_names{f_num}), param_name_pat, fit_nofit, props);
  end
end

% finally apply to own
a_m.param_func = ...
  selectFitParams(a_m.param_func, param_name_pat, fit_nofit, props);