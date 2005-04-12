function a_plot = plotrow(a_tests_db, row, props)

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
%	props: A structure with any optional properties.
%	  putLabels: Put special column name labels.
%		
%   Returns:
%	a_plot: A plot_abstract object that can be plotted.
%
% See also: plot_abstract, plotFigure
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/11/08

if ~ exist('props')
  props = struct;
end

data = a_tests_db.data;
x_vals = 1:dbsize(a_tests_db, 2);
%#props.XTickLabel = fieldnames(get(a_tests_db, 'col_idx'));
props.XTick = x_vals;
props.grid = 1;

if isfield(props, 'putLabels')
  props.XTickLabel = {''};
end

%# TODO: need special plot_abstract for making colored bars:
%#rows = [x_vals, data(row, :, 1)];
%#flatrow = num2cell(reshape(rows, 1, 2*length(x_vals)));

a_plot = ...
    plot_abstract({ x_vals, data(row, :, 1) }, {'', ''}, ...
		  get(a_tests_db, 'id'), {}, 'bar', ...
		  props);

if isfield(props, 'putLabels')
  [label_plots(1:dbsize(a_tests_db, 2))] = deal(plot_abstract);

  col_names = fieldnames(get(a_tests_db, 'col_idx'));
  for col=1:dbsize(a_tests_db, 2)
    label_plots(col) = ...
	plot_abstract({ col/(dbsize(a_tests_db, 2) + 1), -0.03, col_names{col}, ...
		       struct('Units', 'normalized', ...
			      'HorizontalAlignment', 'right', ...
			      'Rotation', 20)}, {'', ''}, ...
		      get(a_tests_db, 'id'), {}, 'subTextLabel', props);
  end
  a_plot = plot_superpose( [a_plot, label_plots], {}, '');
end