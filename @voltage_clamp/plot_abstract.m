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
%     label: add this as a line label to be used in superposed plots.
%     onlyPlot: 'i' for current and 'v' for voltage plot.
%     vColors: If 1 (default), always use same colors for same voltage levels.
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
% $Id: plot_abstract.m 142 2010-08-09 17:20:50Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/03/11

% TODO: 
% - let choose I or V
% - make legend optional

props = defaultValue('props', struct);
title_str = defaultValue('title_str', '');

% assume 2nd step is the main pulse
v_steps = a_vc.v_steps(2, :);

v_legend = ...
    cellfun(@(x)([ sprintf('%.0f', x) ' mV']), ...
            num2cell(v_steps'), ...
            'UniformOutput', false);

if isfield(props, 'label')
  plot_label = props.label;
  cur_label = [ 'I_{' props.label '} [nA]' ];
  cur_legends = { plot_label };
else
  plot_label = 'data';
  cur_label = 'I [nA]';
  cur_legends = v_legend;
end

dt = get(a_vc, 'dt') * 1e3;             % convert to ms

data_i = get(a_vc.i, 'data');
data_v = get(a_vc.v, 'data');
cell_name = get(a_vc, 'id');
time = (0:(size(data_i, 1)-1))*dt;

if isfield(props, 'quiet')
  all_title = properTeXLabel(title_str);
else
  all_title = ...
      properTeXLabel([ cell_name title_str ]);
end

% use consistent colors
line_colors = lines(length(v_steps)); 

% common x-axis limits
axis_limits = ...
    getFieldDefault(...
      props, 'axisLimits', ...
      [max(a_vc.time_steps(1) * dt - 10, 0), ...
       min(a_vc.time_steps(end) * dt + 10, size(data_v, 1) * dt), ...
       NaN NaN]);

plot_props = mergeStructs(props, struct('axisLimits', axis_limits));

if ~isfield(props, 'vColors') || props.vColors ~= 0
  plot_props = mergeStructs(plot_props, struct('ColorOrder', line_colors));
end

plot_i = ...
    plot_abstract({time, data_i}, {'time [ms]', cur_label}, ...
                  all_title, cur_legends, 'plot', ...
                  plot_props);

plot_v = ...
    plot_abstract({time, data_v}, ...
                    {'time [ms]', 'V [mV]'}, ...
                    all_title, {plot_label}, 'plot', ...
                    plot_props);

if ~ isfield(props, 'onlyPlot')
  % create a vertical stack plot
  a_p = ...
      plot_stack({setProp(plot_i, 'noLegends', 1), plot_v}, ...
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