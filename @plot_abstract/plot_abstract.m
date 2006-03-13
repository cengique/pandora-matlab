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
%		axisLimits: Sets axis limits of non-NaN values in vector.
%		tightLimits: If 1, issues an "axis tight" command (default=0)
%		border: Size of border spacing around axis (default=0.01)
%		fontSize: Set the fontsize.
%		grid: Display dashed grid in background.
%		noXLabel: No X-axis label.
%		noYLabel: No Y-axis label.
%		noTitle: No title.
%		rotateXLabel: Rotates the X-axis label for smaller width.
%		rotateYLabel: Rotates the Y-axis label for smaller width.
%		numXTicks: Number of ticks on X-axis.
%		formatXTickLabels: The sprintf format string for tick labels.
%		XTick, YTick: Point locations for axis ticks.
%		XTickLabel, YTickLabel: Axis tick labels.
%		LineStyleOrder: Set the LineStyleOrder of the axis.
%		legendLocation: Passed to legend(..., 'location', legendLocation).
%		legendOrientation: Passed to legend(..., 'orientation', legendLocation).
%		noLegends: If exists, no legends are displayed.
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
   if ~ exist('props')
     props = struct([]);
   end

   if ~ exist('command')
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

