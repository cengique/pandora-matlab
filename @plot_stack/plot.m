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

axes('position', layout_axis);

left_side = layout_axis(1);
bottom_side = layout_axis(2);
width = layout_axis(3);
height = layout_axis(4);

%# Divide the layout area according to number of plots contained
num_plots = length(a_plot.plots);

scale_down = 0.95;
border = 1;

%# Find the width of a regular y-axis label (DOESN'T WORK!)
%#ticklabel = text(0, 0, 'xxx', 'Visible', 'off');
%#tickextent = get(ticklabel, 'Extent');

%# Fixed size for ticks and labels
decosize = 0.03;

a_plot.props

%# Handle special label and tick placements to create maximal plotting area
if isfield(a_plot.props, 'xLabelsPos') 
  switch a_plot.props.xLabelsPos
      case 'bottom'
	bottom_side = bottom_side + decosize / 2;
	height = height - decosize / 2;
	labelheight = 0;
      case 'none'
	labelheight = 0;
      otherwise
	error(['xLabelsPos=' a_plot.props.xLabelsPos ' not recognized.' ]);
    end
else
  %# Check if a parent stacker already separated space for the decorations
  if isfield(a_plot.props, 'noXLabel') && a_plot.props.noXLabel == 0
    labelheight = 0;
  else
    labelheight = decosize / 2;
  end
end

if isfield(a_plot.props, 'xTicksPos') 
  switch a_plot.props.xTicksPos
      case 'bottom'
	bottom_side = bottom_side + decosize / 2;
	height = height - decosize / 2;
	tickheight = 0;
      case 'none'
	tickheight = 0;
      otherwise
	error(['xTicksPos=' a_plot.props.xTicksPos ' not recognized.' ]);
    end
else
  if isfield(a_plot.props, 'noXTickLabels') && a_plot.props.noXTickLabels == 0
    tickheight = 0;
  else
    tickheight = decosize / 2;
  end
end

if isfield(a_plot.props, 'yLabelsPos') 
  switch a_plot.props.yLabelsPos
      case 'left'
	left_side = left_side + decosize;
	width = width - decosize;
	labelwidth = 0;
      case 'none'
	labelwidth = 0;
      otherwise
	error(['yLabelsPos=' a_plot.props.yLabelsPos ' not recognized.' ]);
    end
else
  if isfield(a_plot.props, 'noYLabel') && a_plot.props.noYLabel == 0
    labelwidth = 0;
  else
    labelwidth = decosize;
  end
end

if isfield(a_plot.props, 'yTicksPos') 
  switch a_plot.props.yTicksPos
      case 'left'
	left_side = left_side + decosize;
	width = width - decosize;
	tickwidth = 0;
      case 'none'
	tickwidth = 0;
      otherwise
	error(['yTicksPos=' a_plot.props.yTicksPos ' not recognized.' ]);
    end
else
  if isfield(a_plot.props, 'noYTickLabels') && a_plot.props.noYTickLabels == 0
    tickwidth = 0;
  else
    tickwidth = decosize;
  end
end

labelwidth
labelheight
tickwidth
tickheight

if strcmp(a_plot.orient, 'x')
  tilewidth = border * width / num_plots;
  tileheight = border * height;
elseif strcmp(a_plot.orient, 'y')
  tilewidth = border * width;
  tileheight = border * height / num_plots;
end

%# Put a title first
text(left_side + width / 2, ...
     bottom_side + height + 0.1, ...
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
  if isfield(a_plot.props, 'yTicksPos') && ...
	((plot_num > 1 && strcmp(a_plot.props.yTicksPos, 'left')) || ...
	 strcmp(a_plot.props.yTicksPos, 'none'))
    its_props(1).noYTickLabels = 1;
    %#tickwidth = 0; %# no more space is needed for y-tick labels
  end
  if isfield(a_plot.props, 'yLabelsPos') && ...
	((plot_num > 1 && strcmp(a_plot.props.yLabelsPos, 'left')) || ...
	 strcmp(a_plot.props.yLabelsPos, 'none'))
    its_props(1).noYLabel = 1;
    %#tickwidth = 0; %# no more space is needed for y-tick labels
    %#labelwidth = 0;
  end
  if isfield(a_plot.props, 'xTicksPos') && ...
	((plot_num > 1 && strcmp(a_plot.props.xTicksPos, 'bottom')) || ...
	 strcmp(a_plot.props.xTicksPos, 'none'))
    its_props(1).noXTickLabels = 1;
  else
    its_props(1).noXTickLabels = 0
  end
  if isfield(a_plot.props, 'xLabelsPos') && ...
	((plot_num > 1 && strcmp(a_plot.props.xLabelsPos, 'bottom')) || ...
	 strcmp(a_plot.props.xLabelsPos, 'none'))
    its_props(1).noXLabel = 1;
  else
    %# Signal to plot that it has space to put its labels
    its_props(1).noXLabel = 0
  end
  %# Check if title only for the topmost plot
  if isfield(a_plot.props, 'titlesPos') 
    if 	(plot_num < num_plots && strcmp(a_plot.props.titlesPos, 'top')) || ...
	  strcmp(a_plot.props.titlesPos, 'none')
      its_props(1).noTitle = 1;
    end
  end
  %# Set the modified properties back to the plot
  one_plot = set(one_plot, 'props', its_props);
  %# Calculate subplot positioning
  x_offset = left_side + (1 - scale_down) * tilewidth / 2 + ...
      strcmp(a_plot.orient, 'x') * (plot_num - 1) * tilewidth;
  y_offset = bottom_side + (1 - scale_down) * tileheight / 2 + ...
      strcmp(a_plot.orient, 'y') * (plot_num - 1) * tileheight;
  position = [x_offset, y_offset, ...
	      max(scale_down * tilewidth - tickwidth - labelwidth, minwidth), ...
	      max(scale_down * tileheight - tickheight - labelheight, minheight) ]
  plot(one_plot, position);
  %# Set its axis limits if requested
  if ~ isempty(a_plot.axis_limits)
    axis(a_plot.axis_limits);
  end
  decorate(one_plot);
end

hold off;

