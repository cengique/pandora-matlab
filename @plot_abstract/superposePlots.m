function a_plot = superposePlots(plots, axis_labels, title, command, props)

% superposePlots - Superpose a number of plots onto a single axis.
%
% Usage:
% a_plot = superposePlots(plots, axis_labels, title, command, props)
%
% Description:
%
%   Parameters:
%	plots: A cell array of objects of class plot_abstract or its subclass.
%	axis_labels: Cell array of axis label strings.
%	title: Plot description string.
%	command: Plotting command to use (Optional, default='plot')
%	props: A structure any needed properties.
%		
%   Returns:
%	a_plot: A plot_abstract object.
%
% See also: plot_abstract, plot_abstract/plot, plot_abstract/plotFigure
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/23

a_plot.data = {};
a_plot.data = deal(plots{:}.data{:})

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

