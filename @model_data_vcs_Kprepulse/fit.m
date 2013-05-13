function a_md = fit(a_md, title_str, props)

% fit - Fit model to combined voltage clamp for data_vc and pre_data_vc.
%
% Usage:
% a_md = fit(a_md, title_str, props)
%
% Parameters:
%   a_md: A model_data_vcs object.
%   title_str: (Optional) Text to appear in the plot title.
%   props: A structure with any optional properties.
%     onlyFit: 'step' or 'prestep' would use the data_vc or pre_data_vc
%              for fitting.
%     (passed to model_data_vcs/fit)
% 
% Returns:
%   a_md: Updated object.
%
% Description:
%   WARNING: fitRangeRel, outRangeRel, and fitRange parameters need to be
% re-interpreted because this object will concat the two data files and
% call the super fit function.
%
% Example:
% >> a_md = fit(model_data_vcs(model, data_vc))
%
% See also: model_data_vcs, model_data_vcs/fit, voltage_clamp, plot_abstract, plotFigure
%
% $Id: fit.m 234 2010-10-21 22:06:52Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/21

props = defaultValue('props', struct);
title_str = defaultValue('title_str', '');

if isfield(props, 'onlyFit')
  if strcmp(props.onlyFit, 'step')
    Kall_vc = a_md.model_data_vcs.data_vc;
  elseif strcmp(props.onlyFit, 'prestep')
    Kall_vc = a_md.md_pre.data_vc;
  else
    error([ 'props.onlyFit=''' props.onlyFit ''' not recognized. Use ' ...
                        '''step'' or ''prestep''.']);
  end
else
  % concat two data files
  Kall_vc = a_md.md_pre.data_vc;

  Kall_vc.i.data = [ Kall_vc.i.data, a_md.model_data_vcs.data_vc.i.data ];
  Kall_vc.v.data = [ Kall_vc.v.data, a_md.model_data_vcs.data_vc.v.data ];

  Kall_vc = updateSteps(Kall_vc);
end

% do not allow fitRange and fitRangeRel
if isfield(props, 'fitRangeRel') || isfield(props, 'fitRange')
  error([ 'fitRange and fitRangeRel not allowed for model_data_vcs_Kprepulse ' ...
          'because two voltage protocols are concatenated and must be ' ...
          'simulated one after another.' ]);
end

% re-interpret fitRangeRel params
if isfield(props, 'outRangeRel')
  num_steps = length(Kall_vc.time_steps);
  new_range = [];
  for row_num = 1:size(props.outRangeRel, 1)
    if size(props.outRangeRel, 2) == 2
      props.outRangeRel = [ones(size(props.outRangeRel, 1), 1), ...
                          props.outRangeRel];
    end
    % duplicate each row
    new_range = ...
        [new_range; ...
         props.outRangeRel(row_num, :); ...
         [ (props.outRangeRel(row_num, 1) + num_steps ) props.outRangeRel(row_num, 2:3)]];
  end
  props.outRangeRel = new_range;
  new_range
end

% do fit on new object
a_new_md = fit(model_data_vcs(a_md.model_data_vcs.model_f, Kall_vc), ...
               title_str, mergeStructs(props, struct('plotMd', a_md)));
   
% update model from new object
a_md.model_data_vcs = ...
    updateModel(a_md.model_data_vcs, a_new_md.model_f);
a_md.md_pre = ...
    updateModel(a_md.md_pre, a_new_md.model_f);
