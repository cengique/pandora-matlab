function a_plot = plot_abstract(a_hist_db, title_str, props)

% plot_abstract - Generates a plottable description of this object.
%
% Usage:
% a_plot = plot_abstract(a_hist_db, title_str, props)
%
% Description:
%   Generates a plot_simple object from this histogram.
%
%   Parameters:
%	a_hist_db: A histogram_db object.
%	props: Optional properties passed to plot_abstract.
%		command: Plot command (Optional, default='bar')
%		logScale: If 1, use logarithmic y-scale.
%		quiet: If 1, don't include database name on title.
%		
%   Returns:
%	a_plot: A object of plot_abstract or one of its subclasses.
%
% See also: plot_abstract, plot_simple
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/22

if ~ exist('command') || isempty(command)
  command = 'bar';
end

if ~ exist('props')
  props = struct([]);
end

if ~ exist('title_str')
  title_str = '';
end

%# If input is an array, then return array of plots with the same dimensions
size_dbs = size(a_hist_db);
num_dbs = prod(size_dbs);
if num_dbs > 1 
  %# flatten to array
  flat_dbs = reshape(a_hist_db, num_dbs, 1);
  %# Create array of plots
  [a_plot(1:num_dbs)] = deal(plot_simple);
  for plot_num = 1:num_dbs
    a_plot(plot_num) = plot_abstract(flat_dbs(plot_num), title_str, props);
  end
  %# reshape the output matrix
  a_plot = reshape(a_plot, size_dbs);
  return;
end

%# First column is the variable, second is the histogram
colnames = fieldnames(get(a_hist_db, 'col_idx'));

data = get(a_hist_db, 'data');

%# if the plot is rotated switch the axis labels
if strcmp(command, 'barh')
  x_label = 'Count';
  y_label = strrep(colnames{1}, '_', ' ');
else
  x_label = strrep(colnames{1}, '_', ' ');
  y_label = 'Count';
end

if ~ isfield(props, 'quiet')
  all_title = [ 'Histogram of ' strrep(get(a_hist_db, 'id'), '_', '\_') title_str ];
else
  all_title = title_str;
end

if isfield(props, 'logScale')
  %props.axisProps.YScale = 'log';
  data(:, 2) = log(data(:, 2) + 1);
  y_label = [ 'log ' y_label ];
end

%# Make a simple plot object drawing vertical bars
a_plot = plot_simple(data(:, 1), data(:, 2), ...
		     all_title, ...
		     x_label, y_label, ...
		     colnames{1}, command, props);
