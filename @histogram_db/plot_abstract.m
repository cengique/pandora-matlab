function a_plot = plot_abstract(a_hist_db)

% plot_abstract - Generates a plottable description of this object.
%
% Usage:
% a_plot = plot_abstract()
%
% Description:
%   Generates a plot_simple object from this histogram.
%
%   Parameters:
%	a_hist_db: A histogram_db object.
%		
%   Returns:
%	a_plot: A object of plot_abstract or one of its subclasses.
%
% See also: plot_abstract, plot_simple
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/22

%# First column is the variable, second is the histogram
colnames = fieldnames(get(a_hist_db, 'col_idx'));

data = get(a_hist_db, 'data');

%# Make a simple plot object drawing vertical bars
a_plot = plot_simple(data(:, 1), data(:, 2), ...
		     [ 'Histogram of ' get(a_hist_db, 'id') ], ...
		     colnames{1}, 'Count', ...
		     colnames{1}, 'bar' );
