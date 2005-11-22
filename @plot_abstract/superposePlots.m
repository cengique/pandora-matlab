function a_plot = superposePlots(plots, axis_labels, title_str, command, props)

% superposePlots - Superpose multiple plots with common command onto a single axis.
%
% Usage:
% a_plot = superposePlots(plots, axis_labels, title_str, command, props)
%
% Description:
%   The plot decoration will be taken from the last plot in the list, 
% with the exception of legend labels.
%
%   Parameters:
%	plots: Array of plot_abstract or subclass objects.
%	axis_labels: Cell array of axis label strings (optional, taken from plots).
%	title_str: Plot description string (optional, taken from plots).
%	command: Plotting command to use (optional, taken from plots)
%	props: A structure with any optional properties.
%		NoLegends: If exists, no legends are created.
%		
%   Returns:
%	a_plot: A plot_abstract object.
%
% See also: plot_abstract, plot_abstract/plot, plot_abstract/plotFigure
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/23

if ~ exist('props')
  props = struct;
end

data = {};
legend = {};
for one_plot = plots
  data = {data{:}, one_plot.data{:}};
  if ~isfield(props, 'NoLegends')
    legend = {legend{:}, one_plot.legend{:}};
  else
    legend = {};
  end
end

a_plot = set(plots(1), 'data', data);
a_plot = set(a_plot, 'legend', legend);

if exist('title_str') && ~ isempty(title_str)
  a_plot = set(a_plot, 'title', title_str);
end

if exist('command') && ~ isempty(command)
  a_plot = set(a_plot, 'command', command);
end

if exist('axis_labels') && ~ isempty(axis_labels)
  a_plot = set(a_plot, 'axis_labels', axis_labels);
end
