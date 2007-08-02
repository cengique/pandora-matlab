function obj = plot_abstract(data, axis_labels, title, legend, command, props)

% plot_abstract - Abstract description of a single plot.
%
% Usage:
% obj = plot_abstract(data, axis_labels, title, legend, command, props)
%
% Description:
%   Base class that holds the necessary data to draw a plot. This data
% can then be used to generate different plots. Subclasses define specific
% plots with additional data. Subclasses should conform to the standard 
% that the series of commands found in plotFigure should produce a valid
% figure.
%
%   Parameters:
%	data: A cell array of data arrays (x, y, z, etc.) that can be 
%		fed to plot commands.
%	axis_labels: Cell array of axis label strings.
%	title: Plot description string.
%	legend: Cell array of descriptions for each item plotted.
%	command: Plotting command to use (Optional, default='plot')
%	props: A structure with any optional properties.
%	  axisLimits: Sets axis limits of non-NaN values in vector.
%	  tightLimits: If 1, issues an "axis tight" command (default=0)
%	  border: Relative size of border spacing around axis, between 0 - 1. (default=0)
%	    If a scalar, equal border on all sides, give a four-element vector 
%	    [left bottom right top] to define borders for each side.
%	  fontSize: Set the fontsize.
%	  grid: Display dashed grid in background.
%	  noXLabel: No X-axis label.
%	  noYLabel: No Y-axis label.
%	  noTitle: No title.
%	  rotateXLabel: Rotates the X-axis label for smaller width.
%	  rotateYLabel: Rotates the Y-axis label for smaller width.
%	  numXTicks: Number of ticks on X-axis.
%	  formatXTickLabels: The sprintf format string for tick labels.
%	  XTick, YTick: Point locations for axis ticks.
%	  XTickLabel, YTickLabel: Axis tick labels.
%	  ColorOrder: Set the ColorOrder of the axis.
%	  LineStyleOrder: Set the LineStyleOrder of the axis.
%	  legendLocation: Passed to legend(..., 'location', legendLocation).
%	  legendOrientation: Passed to legend(..., 'orientation', legendLocation).
%	  noLegends: If exists, no legends are displayed.
%	  axisProps: Passed to set properties of the axis drawn.
%	  plotProps: Passed to set properties of the plot drawn.
%	  figureProps: Passed to set properties of the figure drawn.
%	  PaperPosition: Sets the figure property for printing at this size.
%	  resizeControl: If 0, drawing after resize is disabled and prints at screen 
%	    size, if 1 (default), redraws figure after each resize event and 
%	    prints at PaperPosition size.
%		
%   Returns a structure object with the following fields:
%	data, axis_labels, title, legend, command, props
%
% General operations on plot_abstract objects:
%   plot_abstract	- Construct a new plot_abstract object.
%   plot		- Plots this plot in the current axis. Abstract method,
%			needs to be defined for each subclass.
%   plotFigure		- Plots this plot in a new figure window.
%   superposePlots	- Create a superposed plot_abstract from multiple
%			  plot_abstract objects.
%   matrixPlots		- Create a matrix of plots from an array of plot_abstract objects.
%   setProp		- Set optional properties of plot_abstract objects.
%
% Additional methods:
%	See methods('plot_abstract')
%
% See also: plot_abstract/plot, plot_abstract/plotFigure
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/22

if nargin == 0 %# Called with no params
  obj.data = {};
  obj.axis_labels = {};
  obj.title = '';
  obj.legend = {};
  obj.command = {};
  obj.props = struct([]);
  obj = class(obj, 'plot_abstract');
elseif isa(data, 'plot_abstract') %# copy constructor?
  obj = data;
else
   if ~ exist('props', 'var')
     props = struct([]);
   end

   if ~ exist('axis_labels', 'var')
     axis_labels = {};
   end

   if ~ exist('title', 'var')
     title = '';
   end

   if ~ exist('legend', 'var')
     legend = {};
   end

   if ~ exist('command', 'var')
     command = 'plot';
   end

  obj.data = data;
  obj.axis_labels = axis_labels;
  obj.title = title;
  obj.legend = legend;
  obj.command = command;
  obj.props = props;

  obj = class(obj, 'plot_abstract');
end
