function handles = decorate(a_plot)

% decorate - Places decorations (titles, labels, ticks, etc.) on the plot.
%
% Usage:
% handles = decorate(a_plot)
%
% Description:
%
%   Parameters:
%	a_plot: A plot_abstract object, or a subclass object.
%		
%   Returns:
%	handles: Handles of graphical objects drawn.
%
% See also: plot_abstract, plot_abstract/plot
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/22

%# Do the decorations based on properties
th = [];
xh = [];
yh = [];

if ~ (isfield(a_plot.props, 'noTitle') && a_plot.props.noTitle == 1)
  th = title(a_plot.title);
end

if ~ (isfield(a_plot.props, 'noXLabel') && a_plot.props.noXLabel == 1)
  if isfield(a_plot.props, 'rotateXLabel')
    xh = xlabel(a_plot.axis_labels{1}, ...
		'Rotation', a_plot.props.rotateXLabel, ...
		'HorizontalAlignment', 'right', ...
		'VerticalAlignment', 'middle'); %#'HorizontalAlignment', 'right'
  else
    if length(a_plot.axis_labels) > 0
      xh = xlabel(a_plot.axis_labels{1});
    end
  end
else
  xlabel(''); %# Clear the label
end

if ~ (isfield(a_plot.props, 'noYLabel') && a_plot.props.noYLabel == 1)
  if isfield(a_plot.props, 'rotateYLabel')
    yh = ylabel(a_plot.axis_labels{2}, ...
		'Rotation', a_plot.props.rotateYLabel, ...
		'HorizontalAlignment', 'right');
  else
    if length(a_plot.axis_labels) > 1
      yh = ylabel(a_plot.axis_labels{2});
    end
  end
else
  ylabel(''); %# Clear the y-label
end

%# Z-axis?
if isfield(a_plot.props, 'XTickLabel')
  set(gca, 'XTickLabel', a_plot.props.XTickLabel);
end

if isfield(a_plot.props, 'XTick')
  set(gca, 'XTick', a_plot.props.XTick);
end

if isfield(a_plot.props, 'numXTicks')
  num_ticks = a_plot.props.numXTicks - 1;
  axis_limits = get(gca, 'Xlim')
  xticklist = axis_limits(1) + ...
      (0:num_ticks) * (diff(axis_limits([1 2]))) / num_ticks
  xtickscell = cell(1, num_ticks + 1);
  for tick_num=1:(num_ticks+1)
    xtickscell{tick_num} = sprintf('%.2f', xticklist(tick_num));
  end
  xtickscell
  set(gca, 'XTick', xticklist);
  set(gca, 'XTickLabel', xtickscell);
end

if isfield(a_plot.props, 'formatXTickLabels')
  xticks = get(gca, 'XTick');
  xticklabels = get(gca, 'XTickLabel');
  for tick_num=(xticks + 1)

    newstr = sprintf(a_plot.props.formatXTickLabels, str2num(xticklabels(tick_num)));
    xticklabels(tick_num, :) = [newstr ...
				blanks(size(xticklabels, 2) - size(newstr, 2)) ];
  end
  %#xticklist = sprintf([a_plot.props.formatXTickLabels '\n'], str2num(xticklist))
  set(gca, 'XTickLabel', xticklabels);
end

if isfield(a_plot.props, 'YTickLabel')
  set(gca, 'YTickLabel', a_plot.props.YTickLabel);
end

if isfield(a_plot.props, 'YTick')
  set(gca, 'YTick', a_plot.props.YTick);
end

if isfield(a_plot.props, 'grid')
  grid;
end

if isfield(a_plot.props, 'tightLimits') && a_plot.props.tightLimits == 1
  axis tight;
end

%# Only put legend when there is more than one trace
if (length(a_plot.legend) > 1)
  legend_opts = { a_plot.legend };

  if isfield(a_plot.props, 'legendLocation')
    legend_opts = {legend_opts{:}, 'Location', a_plot.props.legendLocation};
  end

  if isfield(a_plot.props, 'legendOrientation')
    legend_opts = {legend_opts{:}, 'Orientation', a_plot.props.legendOrientation};
  end
  
  lh = legend(legend_opts{:});
else
  lh = [];
end

if isfield(a_plot.props, 'axisLimits')
  current_axis = axis;
  %# Skip NaNs, allows fixing some ranges while keeping others flexible
  nonnans = ~isnan(a_plot.props.axisLimits);
  current_axis(nonnans) = a_plot.props.axisLimits(nonnans);
  axis(current_axis);
end

handles = struct('title', th, 'axis_labels', [xh, yh], 'legend', lh);
