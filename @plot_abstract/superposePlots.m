function a_plot = superposePlots(plots, axis_labels, title, command, props)

% superposePlots - Superpose multiple plots with common command onto a single axis.
%
% Usage:
% a_plot = superposePlots(plots, axis_labels, title, command, props)
%
% Description:
%
%   Parameters:
%	plots: A cell array of objects of class plot_abstract or its subclass.
%	axis_labels: Cell array of axis label strings (optional, taken from plots).
%	title: Plot description string (optional, taken from plots).
%	command: Plotting command to use (optional, taken from plots)
%	props: A structure with any optional properties.
%		
%   Returns:
%	a_plot: A plot_abstract object.
%
% See also: plot_abstract, plot_abstract/plot, plot_abstract/plotFigure
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/23

data = {};
legend = {};
for one_plot = plots
  data = {data{:}, one_plot.data{:}};
  legend = {legend{:}, one_plot.legend{:}};
end

a_plot = set(one_plot, 'data', data);
a_plot = set(a_plot, 'legend', legend);
