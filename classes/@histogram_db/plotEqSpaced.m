function a_plot = plotEqSpaced(a_hist_db, command, props)

% plotEqSpaced - Generates a histogram plot where the values are equally spaced on the x-axis. For use with non-linear parameter values.
%
% Usage:
% a_plot = plotEqSpaced(a_hist_db, command, props)
%
% Description:
%   Generates a plot_simple object from this histogram.
%
%   Parameters:
%	a_hist_db: A histogram_db object.
%	command: Plot command (Optional, default='bar')
%	props: Optional properties passed to plot_abstract.
%		
%   Returns:
%	a_plot: A object of plot_abstract or one of its subclasses.
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
% http://opensource.org/licenses/afl-3.0.txt.

if ~ exist('command') || isempty(command)
  command = 'bar';
end

if ~ exist('props')
  props = struct([]);
end

%# If input is an array, then return array of plots
num_dbs = length(a_hist_db);
if num_dbs > 1 
  %# Create array of plots
  [a_plot(1:num_dbs)] = deal(plot_simple);
  for plot_num = 1:num_dbs
    a_plot(plot_num) = plotEqSpaced(a_hist_db(plot_num), command, props);
  end
  return;
end

%# First column is the variable, second is the histogram
colnames = fieldnames(get(a_hist_db, 'col_idx'));

data = get(a_hist_db, 'data');

props(1).XTickLabel = data(:, 1);

%# if the plot is rotated switch the axis labels
if strcmp(command, 'barh')
  x_label = 'Count';
  y_label = colnames{1};
else
  x_label = colnames{1};
  y_label = 'Count';
end

%# Make a simple plot object drawing vertical bars
a_plot = plot_simple(1:dbsize(a_hist_db, 1), data(:, 2), ...
		     [ 'Histogram of ' get(a_hist_db, 'id') ], ...
		     x_label, y_label, ...
		     colnames{1}, command, props);
