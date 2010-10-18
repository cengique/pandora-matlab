function a_p = plotDataCompare(a_md, title_str, props)

% plotDataCompare - Superpose model and data raw traces.
%
% Usage:
% a_p = plotDataCompare(a_md, title_str, props)
%
% Parameters:
%   a_md: A model_data_vcs_DmNav object.
%   title_str: (Optional) Text to appear in the plot title.
%   props: A structure with any optional properties.
%     quiet: If 1, only use given title_str.
%     zoom: Zoom into activation or inactivation parts if 'act' or
%           'inact', resp.
%     show: 'sub' for subtracted current, and 'v' for voltage trace at
%     	    the bottom row.
%     levels: Only plot these current and voltage levels
%     axisLimits: Set current traces to these limits unless 'zoom' prop
%     	    is specified.
% 
% Returns:
%   a_p: A plot_abstract object.
%
% Description:
%
% Example:
% >> a_md = model_data_vcs_DmNav(model, data_vc)
% >> plotFigure(plotDataCompare(a_md, 'my model'))
%
% See also: model_data_vcs_DmNav, voltage_clamp, plot_abstract, plotFigure
%
% $Id: plotDataCompare.m 89 2010-04-09 19:54:00Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/12

if ~ exist('props', 'var')
  props = struct;
end

if ~ exist('title_str', 'var')
  title_str = '';
end

% all specific to DmNavs
label_zoom = '';
% $$$ if isfield(props, 'zoom')
% $$$   if strcmp(props.zoom, 'act')
% $$$     axis_limits = [23 37 -1100 100];
% $$$     label_zoom = ' - zoom act';
% $$$   elseif strcmp(props.zoom, 'inact')
% $$$     axis_limits = [123 135 -1000 200];
% $$$     label_zoom = ' - zoom inact';
% $$$   else
% $$$     error([ 'props.zoom = ''' props.zoom ''' not recognized. Use ''act'' ' ...
% $$$             'or ''inact''.' ]);
% $$$   end
% $$$ else
  axis_limits = getFieldDefault(props, 'axisLimits', [NaN NaN NaN NaN]); %[20 140 -1000 200]
% $$$   end

if isfield(props, 'quiet')
  all_title = title_str;
else
  all_title = [ ', ' a_md.id label_zoom title_str ];
end

line_colors = lines(size(a_md.data_vc.v_steps, 2)); %hsv(length(v_steps));

if isfield(props, 'levels')
  use_levels = props.levels;
  a_md.data_vc = setLevels(a_md.data_vc, use_levels);
  a_md.model_vc = setLevels(a_md.model_vc, use_levels);
end

a_p = ...
    plot_superpose({...
      plot_abstract(a_md.data_vc, all_title, ...
                    struct('onlyPlot', 'i', ...
                           'axisLimits', axis_limits, 'noLegends', 1, ...
                           'ColorOrder', line_colors)), ...
      plot_abstract(a_md.model_vc, '', ...
                    struct('onlyPlot', 'i', 'plotProps', ...
                           struct('LineWidth', 2)))}, {}, '', ...
                   mergeStructs(props, struct('noCombine', 1, 'noTitle', 1, ...
                                              'fixedSize', [4 3])));

if isfield(props, 'show') 
  if strcmp(props.show, 'sub')
    b_p = ...
        plot_abstract(a_md.data_vc - a_md.model_vc, '', ...
                      struct('onlyPlot', 'i', 'ColorOrder', line_colors, ...
                             'plotProps', struct('LineWidth', 1)));
  elseif strcmp(props.show, 'v')
    b_p = ...
        plot_abstract(a_md.data_vc, '', ...
                      struct('onlyPlot', 'v', 'ColorOrder', line_colors, ...
                             'axisLimits', axis_limits, ...
                             'plotProps', struct('LineWidth', 1)));
  end
  a_p = ...
      plot_stack({a_p, b_p}, ...
                 [], 'y', all_title, ...
                 mergeStructs(props, ...
                              struct('titlesPos', 'none', 'xLabelsPos', 'bottom', ...
                                     'fixedSize', [4 3], 'noTitle', 1, ...
                                     'relativeSizes', [3 1])));
end % func