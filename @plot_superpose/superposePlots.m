function a_plot = superposePlots(plots, axis_labels, title_str, command, props)

% superposePlots - Superpose multiple plot_superpose objects by merging them into one.
%
% Usage:
% a_plot = superposePlots(plots, axis_labels, title_str, command, props)
%
% Description:
%
%   Parameters:
%	plots: Array of plot_superpose objects.
%	axis_labels: Cell array of axis label strings (optional, taken from plots).
%	title_str: Plot description string (optional, taken from plots).
%	command: Plotting command to use (optional, taken from plots)
%	props: A structure with any optional properties.
%		noLegends: If exists, no legends are created.
%		
%   Returns:
%	a_plot: A plot_superpose object.
%
% See also: plot_abstract/superposePlots, plot_stack/superposePlots
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/06/14

if ~ exist('props')
  props = struct;
end

a_plot = plots(1);

%# Combine plots and legend fields into one plot_superpose object
num_plots = length(plots);
if num_plots > 1
  for plot_num = 2:num_plots
    a_plot.plots = {a_plot.plots{:}, plots(plot_num).plots{:}};
    a_legend = get(a_plot, 'legend');
    w_legend = get(plots(plot_num), 'legend');
    a_plot = set(a_plot, 'legend', { a_legend{:}, w_legend{:}});
  end
end
