function a_plot = plot_stack(plots, axis_limits, orient, title, props)

% plot_stack - A horizontal or vertical stack of plots.
%
% Usage:
% a_plot = plot_stack(plots, axis_limits, orient, title, props)
%
% Description:
%   Subclass of plot_abstract. Contains other plot_abstract objects or
% subclasses thereof to be layout in stack format. 
%
%   Parameters:
%	plots: Cell array of plot_abstract or subclass objects.
%	axis_limits: If given, all plots contained will have these axis limits.
%	orient: Stack orientation 'x' for horizontal, 'y' for vertical, etc.
%	title: Title to go on top of the stack
%	props: A structure with any optional properties.
%		yLabelsPos: 'left' means only put y-axis label to leftmost plot.
%		yTicksPos: 'left' means only put y-axis ticks to leftmost plot.
%		xLabelsPos: 'bottom' means only put x-axis label to lowest plot.
%		xTicksPos: 'bottom' means only put x-axis ticks to lowest plot.
%		titlesPos: 'top' means only put title to top plot.
%		
%   Returns a structure object with the following fields:
%	plot_abstract, plots, axis_limits, orient, props.
%
% General operations on plot_stack objects:
%   plot_stack		- Construct a new plot_stack object.
%   plot		- Layout this stack at given axis position.
%
% Additional methods:
%	See methods('plot_stack')
%
% See also: plot_abstract, plot_abstract/plotFigure
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/04

if nargin == 0 %# Called with no params
  a_plot.plots = {};
  a_plot.axis_limits = [];
  a_plot.orient = 'y';
  a_plot.props = struct([]);
  a_plot = class(a_plot, 'plot_stack', plot_abstract);
 elseif isa(plots, 'plot_stack') %# copy constructor?
   a_plot = plots;
 else
   if ~ exist('props')
     props = struct([]);
   end

   if ~ exist('orient')
     orient = 'y';
   end

   if ~ exist('axis_limits')
     axis_limits = [];
   end

   %# Loop through plots and set properties

   a_plot.plots = plots;
   a_plot.axis_limits = axis_limits;
   a_plot.orient = orient;
   a_plot.props = props;

   %# Initialize with empty plot_abstract instance
   %# because we override most of the default behavior
   %# defined there anyway.
   a_plot = class(a_plot, 'plot_stack', plot_abstract([], {}, title, {}, ''));
end

