function a_p = plot_abstract(a_md, title_str, props)

% plot_abstract - Superpose model and data raw traces.
%
% Usage:
% a_p = plot_abstract(a_md, title_str, props)
%
% Parameters:
%   a_md: A model_data_vcs object.
%   title_str: (Optional) Text to appear in the plot title.
%   props: A structure with any optional properties.
%     quiet: If 1, only use given title_str.
%     zoom: Zoom into activation or inactivation parts if 'act' or
%           'inact', resp. Can be a cell to have multiple of these.
%     skipStep: Number of voltage steps to skip at the start for zoom (default=0).
%     show: 'sub' for subtracted current, and 'v' for voltage trace at
%     	    the bottom row.
%     levels: Only plot these current and voltage levels
%     colorLevels: Cycle colors every this number.
%     axisLimits: Set current traces to these limits unless 'zoom' prop
%     	    is specified. If it has multiple rows, create multiple data
%     	    plots for each set of limits.
%     vLimits: If given, limit all voltage plot X axes to these.
%     iLimits: If specified, override axisLimits y-axis values with these
%     	    only for the data plot (not the subtraction plot).
% 
% Returns:
%   a_p: A plot_abstract object.
%
% Description:
%
% Example:
% >> a_md = model_data_vcs(model, data_vc)
% >> plotFigure(plot_abstract(a_md, 'my model'))
%
% See also: model_data_vcs, voltage_clamp, plot_abstract, plotFigure
%
% $Id: plot_abstract.m 238 2010-10-22 22:41:07Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/12

if ~ exist('props', 'var')
  props = struct;
end

if ~ exist('title_str', 'var')
  title_str = '';
end

if isfield(props, 'quiet')
  all_title = title_str;
else
  all_title = [ get(a_md, 'id') title_str ];
end

if isfield(props, 'zoom') && iscell(props.zoom)
  data_p = plot_stack({...
        plotDataCompare(a_md, title_str, ...
                      mergeStructs(rmfield(props, 'zoom'), ...
                                   struct('showSub', 1, 'showV', 1, ...
                                   'zoom', props.zoom{1}))), ...
        plotDataCompare(a_md, title_str, ...
                      mergeStructs(rmfield(props, 'zoom'), ...
                                   struct('showSub', 1, 'showV', 1, ...
                                   'zoom', props.zoom{2})))}, [], 'x', '', ...
                                   struct('yLabelsPos', 'left', 'yTicksPos', 'left'));
elseif isfield(props, 'axisLimits') && size(props.axisLimits, 1) > 1
    % make an X-stack of several plots with different zooms into specified axisLimits
    data_ps = {};
    for limit_num = 1:size(props.axisLimits, 1)
        data_ps{limit_num} = ...
            plotDataCompare(a_md, title_str, ...
                      mergeStructs(rmfield(props, 'axisLimits'), ...
                                   struct('showSub', 1, 'showV', 1, ...
                                   'axisLimits', props.axisLimits(limit_num, :))));
    end
    data_p = plot_stack(data_ps, [], 'x', '', ...
                        struct('yLabelsPos', 'left', 'yTicksPos', 'left'));
else
    data_p = ...
        plotDataCompare(a_md, title_str, ...
                      mergeStructs(props, ...
                                   struct('showSub', 1, 'showV', 1)));
end

v_props = ...
    struct('titlesPos', 'none', 'xLabelsPos', 'bottom');
v_limits = [];

if isfield(props, 'vLimits')
    v_props = mergeStructs(struct('xTicksPos', 'bottom'), v_props);
    v_limits = [props.vLimits NaN NaN];
end

% put legends outside for the right side plots
side_props = ...
    mergeStructs(props, struct('legendLocation', 'EastOutside'));

% main plot axisLimits don't apply to v-dep plots
if isfield(side_props, 'axisLimits')
  side_props = rmfield(side_props, 'axisLimits');
end

a_p = ...
    plot_stack({...
      data_p, ...
      plot_stack({plotPeaksCompare(a_md, '', side_props), ...
                  plotModelInfs(a_md, '', side_props), ...
                  plotModelTaus(a_md, '', side_props)}, v_limits, 'y', '', ...
                 v_props)}, ...
               [], 'x', all_title, ...
               mergeStructs(props, ...
                            struct('titlesPos', 'none', 'xLabelsPos', 'bottom', ...
                                   'relativeSizes', [2 2], ...
                                   'fixedSize', [8 5], 'noTitle', 1)));
