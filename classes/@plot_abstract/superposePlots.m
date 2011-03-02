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
%		noLegends: If exists, no legends are created.
%		
%   Returns:
%	a_plot: A plot_abstract object.
%
% See also: plot_abstract, plot_abstract/plot, plot_abstract/plotFigure
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/23

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

command = '';
data = {};
legend = {};
a_props = struct;
color_order = [];
if length(plots) > 1
  for one_plot = plots
    if isempty(command)
      command = one_plot.command;
    else
      if ~strcmp(command, one_plot.command) || strcmp(command, 'errorbar')
	warning('mixed-command plot, using plot_superpose instead.');
        plot_props = struct;
        if strcmp(command, 'errorbar')
          plot_props.noCombine = 1;
        end
	a_plot = plot_superpose(num2cell(plots), {}, '', ...
                                mergeStructsRecursive(props, plot_props));
	return;
      end
    end
    one_props = get(one_plot, 'props');
    if isfield(one_props, 'ColorOrder')
      color_order = [color_order; one_props.ColorOrder];
    end
    a_props = mergeStructsRecursive(a_props, one_props);
    if isempty(data)
      data = one_plot.data;
    else
      if strcmp(command, 'bar')
        % special case for bar plots, add as columns
        % keep x-axis values from the 1st plot
        data{2} = [ data{2}, one_plot.data{2} ];
      else
        % general case (e.g., plot command) add vectors as input to command.
        data = {data{:}, one_plot.data{:}};
      end
    end
    if ~isfield(props, 'noLegends')
      legend = {legend{:}, one_plot.legend{:}};
    else
      legend = {};
    end
  end % of for one_plot
  if ~isempty(color_order), a_props.ColorOrder = color_order; end
else
  data = plots.data;
  legend = plots.legend;
  a_props = get(plots, 'props');
end

a_plot = set(plots(1), 'data', data);
a_plot = set(a_plot, 'props', mergeStructsRecursive(props, a_props));
a_plot = set(a_plot, 'legend', legend);

if exist('title_str', 'var') && ~ isempty(title_str)
  a_plot = set(a_plot, 'title', title_str);
end

if exist('command', 'var') && ~ isempty(command)
  a_plot = set(a_plot, 'command', command);
end

if exist('axis_labels', 'var') && ~ isempty(axis_labels)
  a_plot = set(a_plot, 'axis_labels', axis_labels);
end
