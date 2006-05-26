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

%# Get generic verbose switch setting
vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

a_plot_props = get(a_plot, 'props');

minwidth = 0.001;
minheight = 0.001;

%# Setting up the layout_axis is the same as in plot_abstract/plot.m
%# This must be the only code repeated between the two.
if isfield(a_plot_props, 'border')
  border = a_plot_props.border;
else
  border = 0;
end

plot_stack_id = [ 'plot_stack(' a_plot.orient ')' ];

if ~ exist('layout_axis')
  layout_axis = [];
end

%# Call parent plot_abstract/plot.m to set up the axis position
%# Open this axis for putting the title only
handles = plot(a_plot.plot_abstract, layout_axis);

this_axis = handles.axis;
layout_axis = get(this_axis, 'Position');

left_side = layout_axis(1);
bottom_side = layout_axis(2);
width = layout_axis(3);
height = layout_axis(4);

%# Hide the axis, but not the title
set(this_axis, 'Visible', 'off');

%# Put the plot_stack title first
if ~isfield(a_plot_props, 'noTitle') || a_plot_props.noTitle == 0
  th = title(get(a_plot, 'title'));
  set(th, 'Visible', 'on')
end

%#disp(sprintf('Position: %0.3f+%0.3f+%0.3fx%0.3f', ...
%#	     left_side, bottom_side, width, height));

%# Divide the layout area according to number of plots contained
num_plots = length(a_plot.plots);

%# Fixed size for ticks and labels
%# Assume 10 pt font
%# Fixed size for ticks and labels, scaled to 10pt font size for current figure
[dx, dy] = calcGraphNormPtsRatio(gcf);
decosize_x = 10 * dx;
decosize_y = 10 * dy;

%# These values are only used to spare space for the first plot,
%# and only if its specified that they have labels or ticks and the rest don't.
%# This added space will be undone in plot_abstract/plot.m so that the 
%# actual plots are the same size as other tiles.
tickheight = 0;
tickwidth = 0;
labelheight = 0;
labelwidth = 0;
titleheight = 0;

if strcmp(a_plot.orient, 'x') 
  if isfield(a_plot_props, 'yLabelsPos') && strcmp(a_plot_props.yLabelsPos, 'left')
    labelwidth = decosize_x;
  end
  
  if isfield(a_plot_props, 'yTicksPos') && strcmp(a_plot_props.yTicksPos, 'left')
    tickwidth = 3 * decosize_x;
  end
end

if strcmp(a_plot.orient, 'y') 
  if isfield(a_plot_props, 'xLabelsPos') && strcmp(a_plot_props.xLabelsPos, 'bottom')
    labelheight = 2 * decosize_y;
  end

  if isfield(a_plot_props, 'xTicksPos') && strcmp(a_plot_props.xTicksPos, 'bottom')
    tickheight = decosize_y;
  end
end

%# If only topmost plot has title, give it more space
if isfield(a_plot_props, 'titlesPos') && strcmp(a_plot_props.titlesPos, 'top')
  titleheight = 2 * decosize_y;
end

if strcmp(a_plot.orient, 'x')
  tilewidth = max(width - labelwidth - tickwidth, minwidth) / num_plots;
  tileheight = height;
elseif strcmp(a_plot.orient, 'y')
  tilewidth = width;
  tileheight = max(height - labelheight - tickheight - titleheight, minheight) / num_plots;
end

%# Lay the stack out in a loop
for plot_num=1:num_plots
  %# Initialize space variables
  left_space = 0;
  bottom_space = 0;
  title_space = 0;

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
  %# Warning: one_plot's props are superceded by the plot_stack props
  %# done for getting the correct label behaviro, etc. (experimental)
  %#its_props = mergeStructs(a_plot_props, get(one_plot, 'props'));
  its_props = get(one_plot, 'props');

  %# Check if y-ticks only for the leftmost plot
  if isfield(a_plot_props, 'yTicksPos') 
    if ((plot_num > 1 && strcmp(a_plot_props.yTicksPos, 'left') && ...
	 strcmp(a_plot.orient, 'x')) || ...
	strcmp(a_plot_props.yTicksPos, 'none'))
      its_props(1).YTickLabel = {};
    else
      %# Then, allocate space only for this first plot.
      left_space = tickwidth;
      %#its_props(1).YTickLabel = 1; is this required?    
      if verbose
	disp([ plot_stack_id ': allocating one-time space for y-ticks.' ]);
      end
    end
  end
  if isfield(a_plot_props, 'yLabelsPos') 
    if ((plot_num > 1 && strcmp(a_plot_props.yLabelsPos, 'left') && ...
	 strcmp(a_plot.orient, 'x')) || ...
	strcmp(a_plot_props.yLabelsPos, 'none')) 
      its_props(1).noYLabel = 1;
    else
      %# Then, allocate space only for this first plot.
      left_space = left_space + labelwidth;
      if ~isfield(its_props, 'noYLabel') || its_props.noYLabel == 0
	its_props(1).noYLabel = 0;
      end
      if verbose
	disp([[ plot_stack_id ': allocating one-time ' num2str(left_space) ' space for y-label.' ]]);
      end
    end
  end

  if isfield(a_plot_props, 'xTicksPos') && ...
	((plot_num > 1 && strcmp(a_plot_props.xTicksPos, 'bottom') && ...
	  strcmp(a_plot.orient, 'y')) || ...
	 strcmp(a_plot_props.xTicksPos, 'none'))
    its_props(1).XTickLabel = {};
  else
    bottom_space = tickheight;
    if verbose
      disp([ plot_stack_id ': allocating one-time space for x-ticks.' ]);
    end
    %#its_props(1).XTickLabel = 1;
  end
  if isfield(a_plot_props, 'xLabelsPos') && ...
	((plot_num > 1 && strcmp(a_plot_props.xLabelsPos, 'bottom') && ...
	  strcmp(a_plot.orient, 'y')) || ...
	 strcmp(a_plot_props.xLabelsPos, 'none'))
    its_props(1).noXLabel = 1;
  else
    %# Signal to plot that it has space to put its labels
    bottom_space = bottom_space + labelheight;
    if ~isfield(its_props, 'noXLabel') || its_props.noXLabel == 0
      its_props(1).noXLabel = 0;
    end
    if verbose
      disp([ plot_stack_id ': allocating one-time ' num2str(bottom_space) ' space for x-label.' ]);
      end
  end
  %# Check if title only for the topmost plot
  if isfield(a_plot_props, 'titlesPos') 
    if 	(plot_num < num_plots && strcmp(a_plot_props.titlesPos, 'top') && ...
	 strcmp(a_plot.orient, 'y'))
      its_props(1).noTitle = 1;
    else
      title_space = titleheight;
    end
    if strcmp(a_plot_props.titlesPos, 'none')
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
  %#x_offset = left_side + ...
  %#    strcmp(a_plot.orient, 'x') * (plot_num - 1) * tilewidth;
  %#y_offset = bottom_side + ...
  %#    strcmp(a_plot.orient, 'y') * (plot_num - 1) * tileheight;
  %#position = [x_offset, y_offset, ...
  %#	      max(tilewidth - tickwidth - labelwidth, minwidth), ...
  %#	      max(tileheight - tickheight - labelheight - titleheight, minheight) ];
  x_offset = left_side + labelwidth + tickwidth - left_space + ...
      strcmp(a_plot.orient, 'x') * (plot_num - 1) * tilewidth;
  y_offset = bottom_side  + labelheight + tickheight - bottom_space + ...
      strcmp(a_plot.orient, 'y') * (plot_num - 1) * tileheight;
  position = [x_offset, y_offset, ...
  	      tilewidth + left_space, ...
  	      tileheight + bottom_space + title_space ];
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
    current_axis(4) = current_axis(4) + axis_height * .1;
  end
  axis(current_axis);
  %# Place other decorations
  decorate(one_plot);
end

hold off;
