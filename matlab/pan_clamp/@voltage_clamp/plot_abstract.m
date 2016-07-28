function a_p = plot_abstract(a_vc, title_str, props)

% plot_abstract - Plot of the I and V traces of voltage clamp object.
%
% Usage:
% a_p = plot_abstract(a_vc, title_str, props)
%
% Parameters:
%   a_vc: A voltage clamp object.
%   title_str: (Optional) Text to appear in the plot title.
%   props: A structure with any optional properties.
%     quiet: If 1, only use given title_str.
%     vStep: Index of step with varying voltages (default=2).
%     label: add this as a line label to be used in superposed plots.
%     onlyPlot: 'i' for current and 'v' for voltage plot.
%     curUnit: Display units for current trace (default='nA').
%     vColors: If 1 (default), always use same colors for same voltage levels.
%     vColorsFunc: Function to get voltage colors (default=@lines)
%     zoom: If specified, zoom x-axis limits to from just before
%     		the first step to just after the last one.
%     axisLimits: Specify axis limits to stop automatic zoom to
%     		first step (e.g. [NaN NaN NaN NaN]).
%     yLimitsI, yLimitsV: Two element array for y-axis limits of
%     		current and voltage panels, respectively.
%     (rest passed to plot_stack and plot_abstract)
%		
% Returns:
%   a_p: A plot_abstract object.
%
% Description:
%   Can be stacked or superposed with other plot objects.
%
% Example:
% >> a_vc = abf2voltage_clamp('data-dir/cell-A.abf')
% >> plotFigure(plot_abstract(a_vc, 'I/V curve'))
%
% See also: plotSteadyIV, plot_abstract, plotFigure, plot_superpose, plot_stack
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/03/11

% TODO: 
% - make legend optional

props = defaultValue('props', struct);
title_str = defaultValue('title_str', '');

cur_unit = getFieldDefault(props, 'curUnit', 'nA');

switch (cur_unit)
  case 'nA'
    cur_scale = 1;
  case 'pA'
    cur_scale = 1e3;
  otherwise
    error([ 'props.curUnit = ''' cur_unit ...
            ''' not recognized. Use only nA or pA.']);
end

try
  % assume 2nd step is the main pulse
  v_steps = a_vc.v_steps(getFieldDefault(props, 'vStep', 2), :);

  v_legend = ...
      cellfun(@(x)([ sprintf('%.0f', x) ' mV']), ...
              num2cell(v_steps'), ...
              'UniformOutput', false);

  vcolor_func = getFieldDefault(props, 'vColorsFunc', @lines);

  % use consistent colors
  line_colors = feval(vcolor_func, length(v_steps));
catch
  warning('Cannot find voltage steps. Ignoring.');
  v_legend = {};
  line_colors = lines(6);
end

if isfield(props, 'label')
  plot_label = props.label;
  cur_label = [ 'I_{' props.label '} [' cur_unit ']' ];
  cur_legends = { plot_label };
else
  plot_label = 'data';
  cur_label = [ 'I [' cur_unit ']' ];
  cur_legends = v_legend;
end

if isfield(props, 'timeScale') && props.timeScale == 's'
  dt = get(a_vc, 'dt');
else
  dt = get(a_vc, 'dt') * 1e3;             % convert to ms
end

data_i = get(a_vc.i, 'data') * cur_scale;
data_v = get(a_vc.v, 'data');
cell_name = get(a_vc, 'id');

if isfield(props, 'quiet')
  all_title = properTeXLabel(title_str);
else
  all_title = ...
      properTeXLabel([ cell_name title_str ]);
end

if isfield(props, 'zoom')
  % common x-axis limits
  axis_limits = ...
      getFieldDefault(...
          props, 'axisLimits', ...
          [max(a_vc.time_steps(1) * dt - 10, 0), ...
           min(a_vc.time_steps(end) * dt + 10, size(data_v, 1) * dt), ...
           NaN NaN]);
else
  axis_limits = ...
      getFieldDefault(props, 'axisLimits', [NaN NaN NaN NaN]);
end

plot_props = props;

if ~isfield(props, 'vColors') || props.vColors ~= 0
  plot_props = mergeStructs(plot_props, struct('ColorOrder', line_colors));
end

y_limits_i = getFieldDefault(props, 'yLimitsI', [NaN NaN]);
y_limits_v = getFieldDefault(props, 'yLimitsV', [NaN NaN]);

plot_i = ...
    set(plot_abstract(a_vc.i, all_title, ...
                      mergeStructs(struct('axisLimits', ...
                                          [ axis_limits(1:2) ...
                    y_limits_i ]), plot_props)), 'legend', cur_legends);

plot_v = ...
    set(plot_abstract(a_vc.v, all_title, ...
                      mergeStructs(struct('axisLimits', ...
                                          [ axis_limits(1:2) ...
                    y_limits_v ]), plot_props)), 'legend', {plot_label});

if ~ isfield(props, 'onlyPlot')
  % create a vertical stack plot
  a_p = ...
      plot_stack({plot_i, plot_v}, ...
                 axis_limits, ...
                 'y', all_title, ...
                 mergeStructs(props, ...
                              struct('titlesPos', 'none', ...
                                     'xLabelsPos', 'bottom')));
elseif strcmp(props.onlyPlot, 'i')
  a_p = plot_i;
elseif strcmp(props.onlyPlot, 'v')
  a_p = plot_v;
else
  props.onlyPlot
  error([ 'Value of props.onlyPlot (above) not recognized.' ]);
end
