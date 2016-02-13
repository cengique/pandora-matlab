function a_f = selectFitParams(a_f, param_name_pat, fit_nofit, props)

% selectFitParams - Constrain or release model parameters for fitting.
%
% Usage:
% a_f = selectFitParams(a_f, param_name_pat, fit_nofit, props)
%
% Parameters:
%   a_f: A param_func object.
%   param_name_pat: Regular expression pattern compared to parameter names.
%   fit_nofit: 1 for including in fits and 0 for not.
%   props: A structure with any optional properties.
% 
% Returns:
%   a_f: Updated object.
%
% Description:
%   Updates the selectParams props of param_func objects. See getParams.
%
% Example:
% >> a_f = selectFitParams(a_f, 'm.*', 1);
%
% See also: optimize, getParams
%
% $Id: selectFitParams.m 234 2010-10-21 22:06:52Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/05/04

param_names = getParamNames(a_f);

% existing selection: if empty, means all are there
selected = ...
  getFieldDefault(get(a_f, 'props'), 'selectParams', ...
                  param_names);

% find matches from all names
idx = find(cellfun(@(x)(~isempty(x)), ...
                        regexp(param_names, param_name_pat)));

if fit_nofit == 1
  % add to existing list
  a_f = setProp(a_f, 'selectParams', ...
                union(selected, param_names(idx)));
else 
  % remove from existing list
  a_f = setProp(a_f, 'selectParams', ...
                setdiff(selected, param_names(idx)));

end