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
%     curUnit: Display units for current trace (default='nA').
%     vColors: If 1 (default), always use same colors for same voltage levels.
%     vColorsFunc: Function to get voltage colors (default=@lines)
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

% assume 2nd step is the main pulse
v_steps = a_vc.v_steps(2, :);

v_legend = ...
    cellfun(@(x)([ sprintf('%.0f', x) ' mV']), ...
            num2cell(v_steps'), ...
            'UniformOutput', false);

if isfield(props, 'label')
  plot_label = props.label;
  cur_label = [ 'I_{' props.label '} [' cur_unit ']' ];
  cur_legends = { plot_label };
else
  plot_label = 'data';
  cur_label = [ 'I [' cur_unit ']' ];
  cur_legends = v_legend;
end

dt = get(a_vc, 'dt') * 1e3;             % convert to ms

data_i = get(a_vc.i, 'data') * cur_scale;
data_v = get(a_vc.v, 'data');
cell_name = get(a_vc, 'id');
time = (0:(size(data_i, 1)-1))*dt;

if isfield(props, 'quiet')
  all_title = properTeXLabel(title_str);
else
  all_title = ...
      properTeXLabel([ cell_name title_str ]);
end

vcolor_func = getFieldDefault(props, 'vColorsFunc', @lines);

% use consistent colors
line_colors = feval(vcolor_func, length(v_steps)); 

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

% $$$ plot_i = ...
% $$$     plot_abstract({time, data_i}, {'time [ms]', cur_label}, ...
% $$$                   all_title, cur_legends, 'plot', ...
% $$$                   plot_props);
plot_i = ...
    set(plot_abstract(a_vc.i, all_title, plot_props), 'legend', cur_legends);

% $$$ plot_v = ...
% $$$     plot_abstract({time, data_v}, ...
% $$$                     {'time [ms]', 'V [mV]'}, ...
% $$$                     all_title, {plot_label}, 'plot', ...
% $$$                     plot_props);
plot_v = ...
    set(plot_abstract(a_vc.v, all_title, plot_props), 'legend', {plot_label});

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