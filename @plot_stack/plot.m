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

if ~ exist('layout_axis') || isempty(layout_axis)
  %# By default the whole figure area is taken
  layout_axis = [ 0 0 1 1];
end

%# Divide the layout area according to number of plots contained
num_plots = length(a_plot.plots);

scale_down = 0.6;
border = 1;
if strcmp(a_plot.orient, 'x')
  width = border * layout_axis(3) / num_plots;
  height = border * layout_axis(4);
elseif strcmp(a_plot.orient, 'y')
  width = border * layout_axis(3);
  height = border * layout_axis(4) / num_plots;
end

%# Lay them out
for plot_num=1:num_plots
  x_offset = layout_axis(1) + (1 - scale_down) * width / 2 + ...
      strcmp(a_plot.orient, 'x') * ...
      (plot_num - 1) * width;
  y_offset = layout_axis(2) + (1 - scale_down) * height / 2 + ...
      strcmp(a_plot.orient, 'y') * ...
      (plot_num - 1) * height;
  position = [x_offset, y_offset, ...
	      scale_down * width, scale_down * height];
  plot(a_plot.plots{plot_num}, position);
  %# Set its axis limits if requested
  if ~ isempty(a_plot.axis_limits)
    axis(a_plot.axis_limits);
  end
  decorate(a_plot.plots{plot_num});
end

