function [axis_handle, layout_axis] = openAxis(a_plot, layout_axis)

% openAxis - Calculates the extents for the axis of this plot and opens it.
%
% Usage:
% [axis_handle, layout_axis] = openAxis(a_plot, layout_axis)
%
% Description:
%
%   Parameters:
%	a_plot: A plot_abstract object, or a subclass object.
%	layout_axis: The axis position to layout this plot (Optional). 
%		     If NaN, doesn't open a new axis.
%		
%   Returns:
%	handles: Handles of graphical objects drawn.
%
% See also: plot_abstract
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/22

%# Get generic verbose switch setting
vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

%# Verbose greeting
if verbose
  disp([ 'plot_abstract, openAxis(' display(a_plot) ') {' ]);
end

%# Fixed size for ticks and labels, scaled to 10pt font size for current figure
[dx, dy] = calcGraphNormPtsRatio(gcf);
decosize_x = 10 * dx;
decosize_y = 10 * dy;

%#decosize = 0.04;
minwidth = 0.001;
minheight = 0.001;

if isfield(a_plot.props, 'border')
  border = a_plot.props.border;
else
  border = 0;
end

if length(border) == 1
  %# Convert to margins for each edge
  border = [border border border border];
end

%# Put some extra space on right hand side
%# TODO: save the axis handle!
if ~ exist('layout_axis')
  layout_axis = [];
end

%# If a new axis need to be opened, calculate dimensions
if isempty(layout_axis) || ~all(isnan(layout_axis))
  %# apply rightmost and topmost margins for all except plot_stack
  if isa(a_plot, 'plot_stack') 
    top_margin = 0;
    right_margin = 0;
  else
    top_margin = decosize_y;
    right_margin = decosize_x;
  end

  %# If an axis is specified
  if ~isempty(layout_axis)
    left_side = layout_axis(1);
    bottom_side = layout_axis(2);
    width = layout_axis(3) - right_margin;
    height = layout_axis(4) - top_margin;

    if verbose
      disp([ 'plot_abstract, called with axis ->' sprintf('\n') ...
	    'axis: ' num2str([ left_side bottom_side width height ]) ]);
    end
  else  %# Open full size axis
    [ left_side bottom_side width height ] = ...
	deal(border(1), border(2), 1 - (border(1) + border(3)) - right_margin, ...
	     1 - (border(2) + border(4)) - top_margin);
    layout_axis = [ left_side bottom_side width height ];
    if verbose
      disp([ 'plot_abstract: Opening new axis ->' sprintf('\n') ...
	    'axis: ' num2str([ left_side bottom_side width height ]) ]);
    end
  end
end

a_plot_props = get(a_plot, 'props');
if ~isnan(layout_axis)
  plot_axis_labels = get(a_plot, 'axis_labels');
  %# Adjust the axis according to decorations

  %# title
  if ~isempty(get(a_plot, 'title')) && ...
	(~isfield(a_plot_props, 'noTitle') || a_plot_props.noTitle == 0)
    y_strut = 2 * decosize_y;
    %#bottom_side = bottom_side + y_strut;
    height = max(height - y_strut, minheight);
    if verbose
      disp('plot_abstract: alloc space for title.');
    end
  end

  %# X-axis label
  if (~isempty(plot_axis_labels) && ~isempty(plot_axis_labels{1})) && ...
	(~isfield(a_plot_props, 'noXLabel') || a_plot_props.noXLabel == 0)
    y_strut = 2 * decosize_y;
    bottom_side = bottom_side + y_strut;
    height = max(height - y_strut, minheight);
    if verbose
      disp('plot_abstract: alloc space for x-axis label.');
    end
  end
  
  %# X-axis tick labels
  if (~isfield(a_plot_props, 'XTickLabel') || ~isempty(a_plot_props.XTickLabel)) && ...
       ~isa(a_plot, 'plot_stack')
    y_strut = decosize_y;
    bottom_side = bottom_side + y_strut;
    height = max(height - y_strut, minheight);
    if verbose
      disp('plot_abstract: alloc space for x-axis ticks.');
    end
  end

  %# Y-axis label
  if (~isempty(plot_axis_labels) && ~isempty(plot_axis_labels{2})) && ...
	(~isfield(a_plot_props, 'noYLabel') || a_plot_props.noYLabel == 0)
    x_strut = decosize_x;
    left_side = left_side + x_strut;
    width = max(width - x_strut, minwidth);
    if verbose
      disp('plot_abstract: alloc space for y-axis label.');
    end
  end
  
  %# Y-axis tick labels
  if (~isfield(a_plot_props, 'YTickLabel') || ~isempty(a_plot_props.YTickLabel)) && ...
       ~isa(a_plot, 'plot_stack')
    %# Assume 3 chars max
    x_strut = 3 * decosize_x;
    left_side = left_side + x_strut;
    width = max(width - x_strut, minwidth);
    if verbose
      disp('plot_abstract: alloc space for y-axis ticks.');
    end
  end

  if verbose
    disp(['plot_abstract: Creating the axis ->' sprintf('\n') ...
	  'axis: ' num2str([left_side bottom_side width height])]);
  end
  layout_axis = [ left_side bottom_side width height ];
  axis_handle = axes('position', layout_axis);
else
  axis_handle = [];
end

if verbose
  disp([ 'plot_abstract, openAxis() }' ]);
end
