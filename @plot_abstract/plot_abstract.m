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
%		rotateXLabel: Rotates the X-axis label for smaller width.
%		fontSize: Set the fontsize.
%		noXTickLabels: No X-axis tick labels.
%		noYTickLabels: No Y-axis tick labels.
%		
%   Returns a structure object with the following fields:
%	data, axis_labels, title, legend, command, props
%
% General operations on plot_abstract objects:
%   plot_abstract	- Construct a new plot_abstract object.
%   plot		- Plots this plot in the current axis. Abstract method,
%			needs to be defined for each subclass.
%   superpose		- Create a superposed plot_abstract from multiple
%			  plot_abstract objects (N/I).
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

