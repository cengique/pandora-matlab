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

%#disp(sprintf('Position: %0.3f+%0.3f+%0.3fx%0.3f', ...
%#	     left_side, bottom_side, width, height));

%# Divide the layout area according to number of plots contained
num_plots = length(a_plot.plots);

border = 1;

%# Fixed size for ticks and labels
%# Assume 10 pt font
%# Fixed size for ticks and labels, scaled to 10pt font size for current figure
[dx, dy] = calcGraphNormPtsRatio(gca);
decosize_x = 10 * dx;
decosize_y = 10 * dy;

a_plot_props = get(a_plot, 'props');

%# Handle special label and tick placements to create maximal plotting area
if isfield(a_plot_props, 'xLabelsPos') 
  switch a_plot_props.xLabelsPos
      case 'bottom'
	bottom_side = bottom_side + decosize_y / 2;
	height = height - decosize_y / 2;
	labelheight = 0;
      case 'none'
	labelheight = 0;
      otherwise
	error(['xLabelsPos=' a_plot_props.xLabelsPos ' not recognized.' ]);
    end
else
  %# Check if a parent stacker already separated space for the decorations
  if isfield(a_plot_props, 'noXLabel') && a_plot_props.noXLabel == 0
    labelheight = 0;
  else
    bottom_side = bottom_side + decosize_y / 2;
    labelheight = decosize_y / 2;
  end
end

if isfield(a_plot_props, 'xTicksPos') 
  switch a_plot_props.xTicksPos
      case 'bottom'
	bottom_side = bottom_side + decosize_y / 2;
	height = height - decosize_y / 2;
	tickheight = 0;
      case 'none'
	tickheight = 0;
      otherwise
	error(['xTicksPos=' a_plot_props.xTicksPos ' not recognized.' ]);
    end
else
  if isfield(a_plot_props, 'XTickLabel') && isempty(a_plot_props.XTickLabel)
    tickheight = 0;
  else
    bottom_side = bottom_side + decosize_y / 2;
    tickheight = decosize_y / 2;
  end
end

x_strut = decosize_x / 2;
if isfield(a_plot_props, 'yLabelsPos') 
  switch a_plot_props.yLabelsPos
      case 'left'
	left_side = left_side + x_strut;
	width = width - x_strut;
	labelwidth = 0;
      case 'none'
	labelwidth = 0;
      otherwise
	error(['yLabelsPos=' a_plot_props.yLabelsPos ' not recognized.' ]);
    end
else
  if isfield(a_plot_props, 'noYLabel') && a_plot_props.noYLabel == 0
    labelwidth = 0;
  else
    %#left_side = left_side + x_strut;
    labelwidth = 0; %# x_strut
  end
end

x_strut = decosize_x / 4;
if isfield(a_plot_props, 'yTicksPos') 
  switch a_plot_props.yTicksPos
      case 'left'
	left_side = left_side + x_strut;
	width = width - x_strut;
	tickwidth = 0;
      case 'none'
	tickwidth = 0;
      otherwise
	error(['yTicksPos=' a_plot_props.yTicksPos ' not recognized.' ]);
    end
else
  if isfield(a_plot_props, 'YTickLabel') && isempty(a_plot_props.YTickLabel)
    tickwidth = 0;
  else
    %#left_side = left_side + x_strut;
    %#tickwidth = x_strut;
    tickwidth = 0;
  end
end

%# Title math
y_strut = decosize_y;
if ~ isempty(get(a_plot, 'title'))
  if isfield(a_plot_props, 'titlesPos') 
    switch a_plot_props.titlesPos
      case 'top'
	height = height - y_strut;
	titleheight = 0;
      case 'none'
	titleheight = 0;
      case 'all'
	height = height - y_strut;
	titleheight = 0;
      otherwise
	error(['titlesPos=' a_plot_props.titlesPos ' not recognized.' ]);
    end
  else
    titleheight = y_strut;
  end
else
  titleheight = 0;
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
axis_position = get(this_axis, 'Position');
set(this_axis, 'Units', 'normalized');

title_handle = text(axis_position(3) / 2, ...
		    axis_position(4) - 1, ... %#bottom_side + 1.5 * height + 0.0, ...
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

minwidth = 0.001;
minheight = 0.001;

%# Lay them out
for plot_num=1:num_plots
  if strcmp(a_plot.orient, 'x')
    plot_seq = plot_num;
  else
    %# invert the sequence, because matlab starts from bottom in Y axis
    plot_seq = num_plots - plot_num + 1;
  end
  if iscell(a_plot.plots)
    one_plot = a_plot.plots{plot_seq};
  else
    one_plot = a_plot.plots(plot_seq);
  end
  its_props = get(one_plot, 'props');
  %# Check if y-ticks only for the leftmost plot
  if isfield(a_plot_props, 'yTicksPos') && ...
	((plot_num > 1 && strcmp(a_plot_props.yTicksPos, 'left') && ...
	  strcmp(a_plot.orient, 'x')) || ...
	 strcmp(a_plot_props.yTicksPos, 'none'))
    its_props(1).YTickLabel = {};
  else
    %#its_props(1).YTickLabel = 1; is this required?    
  end
  if isfield(a_plot_props, 'yLabelsPos') && ...
	((plot_num > 1 && strcmp(a_plot_props.yLabelsPos, 'left') && ...
	  strcmp(a_plot.orient, 'x')) || ...
	 strcmp(a_plot_props.yLabelsPos, 'none'))
    its_props(1).noYLabel = 1;
  else
    its_props(1).noYLabel = 0;
  end
  if isfield(a_plot_props, 'xTicksPos') && ...
	((plot_num > 1 && strcmp(a_plot_props.xTicksPos, 'bottom') && ...
	  strcmp(a_plot.orient, 'y')) || ...
	 strcmp(a_plot_props.xTicksPos, 'none'))
    its_props(1).XTickLabel = {};
  else
    %#its_props(1).XTickLabel = 1;
  end
  if isfield(a_plot_props, 'xLabelsPos') && ...
	((plot_num > 1 && strcmp(a_plot_props.xLabelsPos, 'bottom') && ...
	  strcmp(a_plot.orient, 'y')) || ...
	 strcmp(a_plot_props.xLabelsPos, 'none'))
    its_props(1).noXLabel = 1;
  else
    %# Signal to plot that it has space to put its labels
    its_props(1).noXLabel = 0;
  end
  %# Check if title only for the topmost plot
  if isfield(a_plot_props, 'titlesPos') 
    if 	(plot_num < num_plots && strcmp(a_plot_props.titlesPos, 'top') && ...
	 strcmp(a_plot.orient, 'y')) || ...
	  strcmp(a_plot_props.titlesPos, 'none')
      its_props(1).noTitle = 1;
    end
  end
  %# Set the modified properties back to the plot
  one_plot = set(one_plot, 'props', its_props);
  %# Calculate subplot positioning
  %#disp(sprintf('left=%.3f, tilewidth=%.3f, tickwidth=%.3f, labelwidth=%.3f', ...
  %#	       left_side, tilewidth, tickwidth, labelwidth));
  %#disp(sprintf('bottom=%.3f, tileheight=%.3f, tickheight=%.3f, labelheight=%.3f, titleheight=%.3f', ...
  %#	       bottom_side, tileheight, tickheight, labelheight, titleheight));
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
  if isfield(a_plot_props, 'relaxedLimits') && a_plot_props.relaxedLimits == 1
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
