function handles = plot(a_plot, layout_axis)

% plot - Draws this plot in the current axis or at the position in
%	layout_axis.
%
% Usage:
% handles = plot(a_plot, layout_axis)
%
% Description:
%
%   Parameters:
%	a_plot: A plot_abstract object, or a subclass object.
%	layout_axis: The axis position to layout this plot (Optional). 
%		
%   Returns:
%	handles: Handles of graphical objects drawn.
%
% See also: plot_stack, plot_abstract
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/04

%# TODO: spare fixed space for axis labels if they exist, not rational space.

if ~ exist('layout_axis') || isempty(layout_axis)
  %# By default the whole figure area is taken
  layout_axis = [ 0 0 1 1];
end

%# Divide the layout area according to number of plots contained
num_plots = length(a_plot.plots);

scale_down = 0.9;
border = 1;

%# Find the width of a regular y-axis label
ticklabel = text(0, 0, 'xxx', 'Visible', 'off');
tickextent = get(ticklabel, 'Extent');
tickwidth = tickextent(3);
tickheight = tickextent(4);

if strcmp(a_plot.orient, 'x')
  width = border * layout_axis(3) / num_plots;
  height = border * layout_axis(4);
elseif strcmp(a_plot.orient, 'y')
  width = border * layout_axis(3);
  height = border * layout_axis(4) / num_plots;
end

%# Put a title first
text(layout_axis(1) + layout_axis(3) / 2, ...
     layout_axis(2) + layout_axis(4) + 0.1, ...
     get(a_plot, 'title'), ...
     'Units', 'Normalized', ...
     'HorizontalAlignment', 'center', 'VerticalAlignment', 'top' );

%# The textbox opens an unwanted axis, so hide it
set(gca, 'Visible', 'off');

minwidth = 0.01;
minheight = 0.01;

%# Lay them out
for plot_num=1:num_plots
  one_plot = a_plot.plots{plot_num};
  its_props = one_plot.props;
  %# Check if y-ticks only for the leftmost plot
  if plot_num > 1 && isfield(a_plot.props, 'yTicksPos') && ...
	strcmp(a_plot.props.yTicksPos, 'left')
    its_props.noYTickLabels = 1;
    tickwidth = 0; %# no more space is needed for y-tick labels
  end
  %# Check if title only for the topmost plot
  if plot_num < num_plots && isfield(a_plot.props, 'titlesPos') && ...
	strcmp(a_plot.props.titlesPos, 'top')
    one_plot = set(one_plot, 'title', '')
  end
  %# Set the modified properties back to the plot
  one_plot = set(one_plot, 'props', its_props);
  %# Calculate subplot positioning
  x_offset = layout_axis(1) + tickwidth + (1 - scale_down) * width / 2 + ...
      strcmp(a_plot.orient, 'x') * (plot_num - 1) * width;
  y_offset = layout_axis(2) + tickheight + (1 - scale_down) * height / 2 + ...
      strcmp(a_plot.orient, 'y') * (plot_num - 1) * height;
  position = [x_offset, y_offset, ...
	      max(scale_down * width - tickwidth, minwidth), ...
	      max(scale_down * height - tickheight, minheight) ];
  plot(a_plot.plots{plot_num}, position);
  %# Set its axis limits if requested
  if ~ isempty(a_plot.axis_limits)
    axis(a_plot.axis_limits);
  end
  decorate(one_plot);
end

hold off;
