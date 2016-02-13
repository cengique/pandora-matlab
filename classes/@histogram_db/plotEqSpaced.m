function a_plot = plotEqSpaced(a_hist_db, title_str, props)

% plotEqSpaced - Generates a histogram plot where the values are equally spaced on the x-axis. For use with non-linear parameter values.
%
% Usage:
% a_plot = plotEqSpaced(a_hist_db, title_str, props)
%
% Parameters:
%   a_hist_db: A histogram_db object.
%   title_str: Optional title string.
%   props: Optional properties passed to plot_abstract.
%     quiet: If 1, don't include database name on title.
%     skipXnum: Skip every this many values to fit labels on X-axis (default=1).
%     totalXnum: Skip to fit this number of total X-axis tick labels.
%		
% Returns:
%   a_plot: A object of plot_abstract or one of its subclasses.
%
% Description:
%   Generates a plot_simple object from this histogram.
%
% See also: plot_abstract, plot_simple
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/22

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('command', 'var') || isempty(command)
  command = 'bar';
end

if ~ exist('props', 'var')
  props = struct([]);
end

if ~ exist('title_str', 'var')
  title_str = '';
end

% If input is an array, then return array of plots
num_dbs = length(a_hist_db);
if num_dbs > 1 
  % Create array of plots
  [a_plot(1:num_dbs)] = deal(plot_simple);
  for plot_num = 1:num_dbs
    a_plot(plot_num) = plotEqSpaced(a_hist_db(plot_num), command, props);
  end
  return;
end

% First column is the variable, second is the histogram
colnames = fieldnames(get(a_hist_db, 'col_idx'));

data = get(a_hist_db, 'data');
all_vals = 1:dbsize(a_hist_db, 1);

skip_x_num = ...
    getFieldDefault(props, 'skipXnum', ...
                           (dbsize(a_hist_db, 1) - 1) / ...
                           max(1, getFieldDefault(props, ...
                                           'totalXnum', ...
                                           (dbsize(a_hist_db, 1) - 1)) - 1));

props(1).XTick = 1:skip_x_num:dbsize(a_hist_db, 1);
props(1).XTickLabel = data(1:skip_x_num:end, 1);

% Call it frequency if it's normalized
a_hist_props = get(a_hist_db, 'props');
if isfield(a_hist_props, 'normalized') && a_hist_props.normalized == 1
  hist_label = 'Frequency';
else
  hist_label = 'Count';
end

% if the plot is rotated switch the axis labels
if strcmp(command, 'barh')
  x_label = hist_label;
  y_label = colnames{1};
else
  x_label = colnames{1};
  y_label = hist_label;
end

if ~ isfield(props, 'quiet')
  all_title = [ 'Histogram of ' strrep(get(a_hist_db, 'id'), '_', '\_') title_str ];
else
  all_title = title_str;
end

% Make a simple plot object drawing vertical bars
a_plot = plot_simple(all_vals, data(:, 2), ...
		     properTeXLabel(all_title), ...
		     properTeXLabel(x_label), properTeXLabel(y_label), ...
		     properTeXLabel(colnames{1}), command, props);
