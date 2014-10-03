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
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/04

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% TODO: 
% - add new prop for affecting deep plot_stack props?
% - correct missing space at bottom

% Get generic verbose switch setting
vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

a_plot_props = get(a_plot, 'props');

minwidth = 0.001;
minheight = 0.001;

% Setting up the layout_axis is the same as in plot_abstract/plot.m
% This must be the only code repeated between the two.
if isfield(a_plot_props, 'border')
  border = a_plot_props.border;
else
  border = 0;
end

plot_stack_id = [ 'plot_stack(' a_plot.orient ')' ];

if verbose
  disp([ plot_stack_id ': starting with props' ]);
  disp(a_plot_props);
end

if ~ exist('layout_axis', 'var')
  layout_axis = [];
end

% Call parent plot_abstract/plot.m to set up the axis position
% Open this axis for putting the title only
[this_axis, layout_axis] = openAxis(a_plot, layout_axis);

left_side = layout_axis(1);
bottom_side = layout_axis(2);
width = layout_axis(3);
height = layout_axis(4);

% Hide the axis, but not the title
set(this_axis, 'Visible', 'off');

% Put the plot_stack title first
if ~isfield(a_plot_props, 'noTitle') || a_plot_props.noTitle == 0
  th = title(get(a_plot, 'title'));
  set(th, 'Visible', 'on')
end

%disp(sprintf('Position: %0.3f+%0.3f+%0.3fx%0.3f', ...
%	     left_side, bottom_side, width, height));

% Pass the spacing cues from the parent plot to the children
if isfield(a_plot_props, 'noXLabel') && a_plot_props.noXLabel == 1
  a_plot_props.xLabelsPos = 'none';
end

if isfield(a_plot_props, 'XTickLabel') && isempty(a_plot_props.XTickLabel)
  a_plot_props.xTicksPos = 'none';
end

if isfield(a_plot_props, 'noYLabel') && a_plot_props.noYLabel == 1
  a_plot_props.yLabelsPos = 'none';
end

if isfield(a_plot_props, 'YTickLabel') && isempty(a_plot_props.YTickLabel)
  a_plot_props.yTicksPos = 'none';
end

% Divide the layout area according to number of plots contained
num_plots = length(a_plot.plots);

% Fixed size for ticks and labels
% Assume 10 pt font
% Fixed size for ticks and labels, scaled to 10pt font size for current figure
[dx, dy] = calcGraphNormPtsRatio(gcf);
decosize_x = 10 * dx;
decosize_y = 10 * dy;

% These values are only used to spare space for the first plot,
% and only if its specified that they have labels or ticks and the rest don't.
% This added space will be undone in plot_abstract/plot.m so that the 
% actual plots are the same size as other tiles.
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

% If only topmost plot has title, give it more space
if isfield(a_plot_props, 'titlesPos') && strcmp(a_plot_props.titlesPos, 'top')
  titleheight = 2 * decosize_y;
end

% If a relative sizing given
if isfield(a_plot_props, 'relativeSizes')
  relative_sizes = a_plot_props.relativeSizes;
  if length(a_plot.plots) ~= length(relative_sizes)
    error([ 'Property relativeSizes (' num2str(length(relative_sizes)) ...
   	    ' items) should have same length as the plots array (' ...
 	    num2str(length(a_plot.plots)) ' items).' ]);
  end
else
  % otherwise all plots are equal size
  relative_sizes = ones(1, length(a_plot.plots));
end

if strcmp(a_plot.orient, 'x')
  tilewidth = max(width - labelwidth - tickwidth, minwidth) / sum(relative_sizes);
  tileheight = height;
elseif strcmp(a_plot.orient, 'y')
  tilewidth = width;
  tileheight = ...
	  max(height - labelheight - tickheight - titleheight, minheight) / ...
	  sum(relative_sizes);
end

% if infs in given axis_limits, find maximal range limits
if any(isinf(a_plot.axis_limits))
  maximal_ranges = [];
  for plot_num=1:num_plots
    if iscell(a_plot.plots)
      one_plot = a_plot.plots{plot_num};
    else
      one_plot = a_plot.plots(plot_num);
    end
    maximal_ranges = growRange([ maximal_ranges; axis(one_plot) ]);
  end
end

% Lay the stack out in a loop
for plot_num=1:num_plots
  % Initialize space variables
  left_space = 0;
  bottom_space = 0;
  title_space = 0;

  if strcmp(a_plot.orient, 'x')
    plot_seq = plot_num;
  else
    % invert the sequence, because matlab starts from bottom in Y axis
    plot_seq = num_plots - plot_num + 1;
  end
  if iscell(a_plot.plots)
    one_plot = a_plot.plots{plot_seq};
  else
    one_plot = a_plot.plots(plot_seq);
  end
  if isempty(one_plot)
    continue;
  end

  % Warning: one_plot's props are superceded by the plot_stack props
  % done for getting the correct label behavior, etc. (experimental)
  %its_props = mergeStructs(a_plot_props, get(one_plot, 'props'));
  its_props = get(one_plot, 'props');

  % Check if y-ticks only for the leftmost plot
  if isfield(a_plot_props, 'yTicksPos') 
    if ((plot_num > 1 && strcmp(a_plot_props.yTicksPos, 'left') && ...
	 strcmp(a_plot.orient, 'x')) || ...
	strcmp(a_plot_props.yTicksPos, 'none'))
      if isa(one_plot, 'plot_stack')
        its_props(1).yTicksPos = 'none';
      else
        its_props(1).YTickLabel = {};
      end
    else
      % Then, allocate space only for this first plot.
      left_space = tickwidth;
      %its_props(1).YTickLabel = 1; is this required?    
      if verbose
	disp([ plot_stack_id ': allocating one-time space for y-ticks.' ]);
      end
    end
  end
  if isfield(a_plot_props, 'yLabelsPos') 
    if ((plot_num > 1 && strcmp(a_plot_props.yLabelsPos, 'left') && ...
	 strcmp(a_plot.orient, 'x')) || ...
	strcmp(a_plot_props.yLabelsPos, 'none')) 
      if isa(one_plot, 'plot_stack')
        its_props(1).yLabelsPos = 'none';
      else
        its_props(1).noYLabel = 1;
      end
    else
      % Then, allocate space only for this first plot.
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
    if isa(one_plot, 'plot_stack')
      its_props(1).xTicksPos = 'none';
    else
      its_props(1).XTickLabel = {};
    end
  else
    bottom_space = tickheight;
    if verbose
      disp([ plot_stack_id ': allocating one-time space for x-ticks.' ]);
    end
    %its_props(1).XTickLabel = 1;
  end
  if isfield(a_plot_props, 'xLabelsPos') && ...
	((plot_num > 1 && strcmp(a_plot_props.xLabelsPos, 'bottom') && ...
	  strcmp(a_plot.orient, 'y')) || ...
	 strcmp(a_plot_props.xLabelsPos, 'none'))
    if isa(one_plot, 'plot_stack')
      its_props(1).xLabelsPos = 'none';
    else
      its_props(1).noXLabel = 1;
    end
  else
    % Signal to plot that it has space to put its labels
    bottom_space = bottom_space + labelheight;
    if ~isfield(its_props, 'noXLabel') || its_props.noXLabel == 0
      its_props(1).noXLabel = 0;
    end
    if verbose
      disp([ plot_stack_id ': allocating one-time ' num2str(bottom_space) ' space for x-label.' ]);
      end
  end
  % Check if title only for the topmost plot
  if isfield(a_plot_props, 'titlesPos') 
    if 	(plot_num < num_plots && strcmp(a_plot_props.titlesPos, 'top') && ...
	 strcmp(a_plot.orient, 'y'))
      if isa(one_plot, 'plot_stack')
        its_props(1).titlesPos = 'none';
        its_props(1).noTitle = 1;
      else
        its_props(1).noTitle = 1;
      end
    else
      title_space = titleheight;
    end
    if strcmp(a_plot_props.titlesPos, 'none')
      if isa(one_plot, 'plot_stack')
        its_props(1).titlesPos = 'none';
        its_props(1).noTitle = 1;
      else
        its_props(1).noTitle = 1;
      end
    end
  end

  % Set the modified properties back to the plot
  one_plot = set(one_plot, 'props', its_props);

  % Calculate subplot positioning
  x_offset = left_side + labelwidth + tickwidth - left_space + ...
      strcmp(a_plot.orient, 'x') * sum(relative_sizes(1:(plot_num - 1))) * tilewidth;
  y_offset = bottom_side  + labelheight + tickheight - bottom_space + ...
      strcmp(a_plot.orient, 'y') * sum(relative_sizes((plot_seq + 1):end)) * tileheight;
  if strcmp(a_plot.orient, 'x')
    this_width = relative_sizes(plot_num) * tilewidth;
    this_height = tileheight;
  else
    this_width = tilewidth;
    this_height = relative_sizes(plot_seq) * tileheight;
  end
  position = [x_offset, y_offset, ...
  	      this_width + left_space, ...
  	      this_height + bottom_space + title_space ];
  one_handle = plot(one_plot, position);
  % Set its axis limits if requested
  current_axis = axis;
  if ~ isempty(a_plot.axis_limits)
    infs = isinf(a_plot.axis_limits);
    if any(infs)
      % replace the infs from the maximal ranges
      a_plot.axis_limits(infs) = maximal_ranges(infs);
    end
    current_axis = setAxisNonNaN(a_plot.axis_limits);
  end
  if isfield(a_plot_props, 'relaxedLimits') && a_plot_props.relaxedLimits == 1
    % Set axis limits to +/- 10% of bounds
    axis_width = current_axis(2) - current_axis(1);
    axis_height = current_axis(4) - current_axis(3);
    current_axis(1) = current_axis(1) - axis_width * .1;
    current_axis(2) = current_axis(2) + axis_width * .1;
    current_axis(3) = current_axis(3) - axis_height * .1;
    current_axis(4) = current_axis(4) + axis_height * .1;
  end
  axis(current_axis);
  % Place other decorations
  one_handle = decorate(one_plot, one_handle);
end

% not used here
handles = [];

hold off;
