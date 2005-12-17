function a_plot = plotRowErrors(db, rows)

% plotRowErrors - Create plot of rankings with errors associated with each measure color-coded.
%
% Usage:
% a_plot = plotRowErrors(db, rows)
%
% Description:
%
%   Parameters:
%	db: A tests_db object.
%	rows: Indices of rows in db.
%		
%   Returns:
%	a_plot: A plot_abstract object.
%
% See also: tests_db, plot_abstract
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/12/12

if ~ exist('rows')
  rows = ':';
end

%# Join with original here. Only joins the requested rows.
joined_db = joinOriginal(db, rows);
joined_data = joined_db.data;

%# Ignore NeuronId?
crit_cols = fieldnames(db.crit_db.col_idx);
all_test_cols(1:length(crit_cols)) = true(1);
if isa(db.crit_db, 'params_tests_db')
  all_test_cols(1:get(db.crit_db, 'num_params')) = false;
end

%# The distance values for each individual measure has the same names in ranked_db
%# Find columns in ranked_db that are also in joined_db except 'Distance'
common_cols = setdiff(intersect(fieldnames(joined_db.col_idx), ...
				fieldnames(get(db, 'col_idx'))), ...
		      {'Distance', 'RowIndex'});

num_std_colors = 10; %# colors for one STD of variance
num_rows = dbsize(joined_db, 1);
distmatx = repmat(NaN, length(common_cols), num_rows);

%# Go through all rows and generate matrix
for row_num = 1:num_rows
  for dist_num = 1:length(common_cols)
    %# Add distance values into matrix
    col = tests2cols(joined_db, common_cols{dist_num});
    distmatx(dist_num, row_num) = ...
	abs(get(onlyRowsTests(db, row_num, common_cols(dist_num)), 'data')) * num_std_colors;
  end
  %names = {names{:}, ['Rank ' num2str(row_num) ], ''};
end

props = struct('XTick', 1:num_rows, 'YTick', 1:length(common_cols));
props.YTickLabel = common_cols;

a_plot = plot_abstract({distmatx, num_std_colors}, {'Ranks', 'Measures'}, ...
		       ['Per-measure errors in ranking ' ...
			strrep(get(db, 'id'), '_', ' ') ], ...
		       {}, @plot_image, props);
end

%# Small function for creating matrix plot
function h = plot_image(distmatx, num_std_colors)
  h = image(distmatx);
  %# Show up to some number of STDs
  colormap(jet(3 * num_std_colors)); 
  %# scale font to fit measure names on y-axis
  set(gca, 'FontUnit', 'normalized', 'FontSize', 1/size(distmatx, 1));
end
