function a_plot = plotrow(a_tests_db, row)

% plotrow - Creates a plot_abstract describing the desired db row.
%
% Usage:
% a_plot = plotrow(a_tests_db, row)
%
% Description:
%
%   Parameters:
%	a_tests_db: A tests_db object.
%	row: Row number to visualize.
%		
%   Returns:
%	a_plot: A plot_abstract object that can be plotted.
%
% See also: plot_abstract, plotFigure
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/11/08

data = a_tests_db.data;
x_vals = 1:size(a_tests_db, 2);
%#props.XTickLabel = fieldnames(get(a_tests_db, 'col_idx'));
props.XTick = x_vals;
props.grid = 1;

%# TODO: need special plot_abstract for making colored bars:
%#rows = [x_vals, data(row, :, 1)];
%#flatrow = num2cell(reshape(rows, 1, 2*length(x_vals)));

a_plot = ...
    plot_abstract({ x_vals, data(row, :, 1) }, {'', ''}, ...
		  get(a_tests_db, 'id'), {}, 'bar', ...
		  props);
