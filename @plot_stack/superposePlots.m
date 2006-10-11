function a_plot = superposePlots(plots, axis_labels, title_str, command, props)

% superposePlots - Superpose multiple plot_stack objects that contain exact same contents.
%
% Usage:
% a_plot = superposePlots(plots, axis_labels, title_str, command, props)
%
% Description:
%   The plot decoration will be taken from the last plot in the list, 
% with the exception of legend labels.
%
%   Parameters:
%	plots: Array of plot_stack objects.
%	axis_labels: Cell array of axis label strings (optional, taken from plots).
%	title_str: Plot description string (optional, taken from plots).
%	command: Plotting command to use (optional, taken from plots)
%	props: A structure with any optional properties.
%		noLegends: If exists, no legends are created.
%		
%   Returns:
%	a_plot: A plot_stack object.
%
% See also: plot_abstract, plot_abstract/plot, plot_abstract/plotFigure
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/06/14

if ~ exist('props')
  props = struct;
end

num_plot_stacks = length(plots);
if num_plot_stacks > 1
  num_plots = length(plots(1).plots);
  
  for plot_num = 1:num_plots
    %# group corresponding subplots in an array
    plot_stacks = {};
    for plot_stack_num = 1:num_plot_stacks
      plot_stacks{plot_stack_num} = plots(plot_stack_num).plots{plot_num};
    end
    %# recurse to handle sub-plot_stacks
    %# collect results in first plot_stack
    %# plot_superpose should call superposePlots if plots are the same class
    plots(1).plots{plot_num} = plot_superpose(plot_stacks);
  end
end

a_plot = plots(1);
