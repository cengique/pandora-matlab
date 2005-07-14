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

this_axis = axes('position', layout_axis);

left_side = layout_axis(1);
bottom_side = layout_axis(2);
width = layout_axis(3);
height = layout_axis(4);

disp(sprintf('Position: %0.3f+%0.3f+%0.3fx%0.3f', ...
	     left_side, bottom_side, width, height));

%# Divide the layout area according to number of plots contained
num_plots = length(a_plot.plots);

scale_down = .9;
border = 1;

%# Find the width of a regular y-axis label (DOESN'T WORK!)
%#ticklabel = text(0, 0, 'xxx', 'Visible', 'off');
%#tickextent = get(ticklabel, 'Extent');

%# Fixed size for ticks and labels
decosize = 0.04;

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
    bottom_side = bottom_side + decosize / 2;
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
  if isfield(a_plot.props, 'XTickLabel') && isempty(a_plot.props.XTickLabel)
    tickheight = 0;
  else
    bottom_side = bottom_side + decosize / 2;
    tickheight = decosize / 2;
  end
end

x_strut = decosize / 2;
if isfield(a_plot.props, 'yLabelsPos') 
  switch a_plot.props.yLabelsPos
      case 'left'
	left_side = left_side + x_strut;
	width = width - x_strut;
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
    left_side = left_side + x_strut;
    labelwidth = x_strut;
  end
end

x_strut = decosize / 4;
if isfield(a_plot.props, 'yTicksPos') 
  switch a_plot.props.yTicksPos
      case 'left'
	left_side = left_side + x_strut;
	width = width - x_strut;
	tickwidth = 0;
      case 'none'
	tickwidth = 0;
      otherwise
	error(['yTicksPos=' a_plot.props.yTicksPos ' not recognized.' ]);
    end
else
  if isfield(a_plot.props, 'YTickLabel') && isempty(a_plot.props.YTickLabel)
    tickwidth = 0;
  else
    left_side = left_side + x_strut;
    tickwidth = x_strut;
  end
end

%# Title math
y_strut = decosize;
if isfield(a_plot.props, 'titlesPos') 
  switch a_plot.props.titlesPos
      case 'top'
	height = height - y_strut;
	titleheight = 0;
      case 'none'
	titleheight = 0;
      otherwise
	error(['titlesPos=' a_plot.props.titlesPos ' not recognized.' ]);
    end
else
  titleheight = y_strut;
end

if strcmp(a_plot.orient, 'x')
  tilewidth = border * width / num_plots;
  tileheight = border * height;
elseif strcmp(a_plot.orient, 'y')
  tilewidth = border * width;
  tileheight = border * height / num_plots;
end

%# Put a title first
%# Position the title using relative measurement
set(this_axis, 'Units', 'characters');
axis_position = get(this_axis, 'Position')
set(this_axis, 'Units', 'normalized');

title_handle = text(axis_position(3) / 2, ...
		    axis_position(4) + 0.5, ... %#bottom_side + 1.5 * height + 0.0, ...
		    get(a_plot, 'title'), ...
		    'Units', 'characters', ...
		    'HorizontalAlignment', 'center', 'VerticalAlignment', 'baseline' );
set(title_handle, 'Units', 'normalized');

%#text(left_side + width / 2, ...
%#     1.05, ... %#bottom_side + 1.5 * height + 0.0, ...
%#     get(a_plot, 'title'), ...
%#     'Units', 'Normalized', ...
%#     'HorizontalAlignment', 'center', 'VerticalAlignment', 'baseline' );

%# The textbox opens an unwanted axis, so hide it
set(gca, 'Visible', 'off');

minwidth = 0.01;
minheight = 0.01;

%# Lay them out
for plot_num=1:num_plots
  if iscell(a_plot.plots)
    one_plot = a_plot.plots{plot_num};
  else
    one_plot = a_plot.plots(plot_num);
  end
  its_props = one_plot.props;
  %# Check if y-ticks only for the leftmost plot
  if isfield(a_plot.props, 'yTicksPos') && ...
	((plot_num > 1 && strcmp(a_plot.props.yTicksPos, 'left') && ...
	  strcmp(a_plot.orient, 'x')) || ...
	 strcmp(a_plot.props.yTicksPos, 'none'))
    its_props(1).YTickLabel = {};
  else
    %#its_props(1).YTickLabel = 1; is this required?    
  end
  if isfield(a_plot.props, 'yLabelsPos') && ...
	((plot_num > 1 && strcmp(a_plot.props.yLabelsPos, 'left') && ...
	  strcmp(a_plot.orient, 'x')) || ...
	 strcmp(a_plot.props.yLabelsPos, 'none'))
    its_props(1).noYLabel = 1;
  else
    its_props(1).noYLabel = 0;
  end
  if isfield(a_plot.props, 'xTicksPos') && ...
	((plot_num > 1 && strcmp(a_plot.props.xTicksPos, 'bottom') && ...
	  strcmp(a_plot.orient, 'y')) || ...
	 strcmp(a_plot.props.xTicksPos, 'none'))
    its_props(1).XTickLabel = {};
  else
    %#its_props(1).XTickLabel = 1;
  end
  if isfield(a_plot.props, 'xLabelsPos') && ...
	((plot_num > 1 && strcmp(a_plot.props.xLabelsPos, 'bottom') && ...
	  strcmp(a_plot.orient, 'y')) || ...
	 strcmp(a_plot.props.xLabelsPos, 'none'))
    its_props(1).noXLabel = 1;
  else
    %# Signal to plot that it has space to put its labels
    its_props(1).noXLabel = 0;
  end
  %# Check if title only for the topmost plot
  if isfield(a_plot.props, 'titlesPos') 
    if 	(plot_num < num_plots && strcmp(a_plot.props.titlesPos, 'top') && ...
	 strcmp(a_plot.orient, 'y')) || ...
	  strcmp(a_plot.props.titlesPos, 'none')
      its_props(1).noTitle = 1;
    end
  end
  %# Set the modified properties back to the plot
  one_plot = set(one_plot, 'props', its_props);
  %# Calculate subplot positioning
  disp(sprintf('left=%.3f, tilewidth=%.3f, tickwidth=%.3f, labelwidth=%.3f', ...
	       left_side, tilewidth, tickwidth, labelwidth));
  disp(sprintf('bottom=%.3f, tileheight=%.3f, tickheight=%.3f, labelheight=%.3f, titleheight=%.3f', ...
	       bottom_side, tileheight, tickheight, labelheight, titleheight));
  %# (1 - scale_down) * tilewidth / 2
  %# (1 - scale_down) * tileheight / 2 +
  x_offset = left_side + ...
      strcmp(a_plot.orient, 'x') * (plot_num - 1) * tilewidth;
  y_offset = bottom_side + ...
      strcmp(a_plot.orient, 'y') * (plot_num - 1) * tileheight;
  position = [x_offset, y_offset, ...
	      max(tilewidth - tickwidth - labelwidth, minwidth), ...
	      max(tileheight - tickheight - labelheight - titleheight, minheight) ];
  plot(one_plot, position);
  %# Set its axis limits if requested
  current_axis = axis;
  if ~ isempty(a_plot.axis_limits)
    %# Skip NaNs, allows fixing some ranges while keeping others flexible
    nonnans = ~isnan(a_plot.axis_limits);
    current_axis(nonnans) = a_plot.axis_limits(nonnans);
  end
  if isfield(a_plot.props, 'relaxedLimits') && a_plot.props.relaxedLimits == 1
    %# Set axis limits to +/- 10% of bounds
    axis_width = current_axis(2) - current_axis(1);
    axis_height = current_axis(4) - current_axis(3);
    current_axis(1) = current_axis(1) - axis_width * .1;
    current_axis(2) = current_axis(2) + axis_width * .1;
    current_axis(3) = current_axis(3) - axis_height * .1;
    current_axis(4) = current_axis(4) + axis_height * .1
  end
  axis(current_axis);
  %# Place other decorations
  decorate(one_plot);
end

hold off;

