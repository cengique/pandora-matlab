function a_plot = plotRowErrors(db, rows, props)

% plotRowErrors - Create plot of rankings with errors associated with each measure color-coded.
%
% Usage:
% a_plot = plotRowErrors(db, rows, props)
%
% Description:
%
%   Parameters:
%	db: A tests_db object.
%	rows: Indices of rows in db.
%	props: A structure with any optional properties.
%	  sortMeasures: If specified, measure order is determined with increasing 
%		overall distance.
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

if ~ exist('props')
  props = struct;
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

%# Sanity check
if num_rows > 500
  error('Too many rows to display!');
end

%# Get matrix of desired rows and columns
distmatx = (abs(get(onlyRowsTests(db, 1:num_rows, common_cols), 'data')) * num_std_colors)';

%# Replace NaNs in distmatx with 3 STD
distmatx(isnan(distmatx)) = 3 * num_std_colors;

if isfield(props, 'sortMeasures')
  [a sorted_idx] = sortrows(sum(distmatx, 2));
  distmatx = distmatx(sorted_idx, :);
  common_cols = common_cols(sorted_idx);
end

plot_props = struct('XTick', 1:num_rows, 'YTick', 1:length(common_cols), 'border', 0.2);
plot_props.YTickLabel = common_cols;

a_plot = plot_abstract({distmatx, num_std_colors}, {'Ranks', 'Measures'}, ...
		       ['Per-measure errors in ranking ' ...
			strrep(get(db, 'id'), '_', ' ') ], ...
		       {}, @plot_image, plot_props);
end

%# Small function for creating matrix plot
function h = plot_image(distmatx, num_std_colors)
  h = image(distmatx);
  %# Show up to some number of STDs
  colormap(jet(3 * num_std_colors)); 
  %# scale font to fit measure names on y-axis
  num_rows = max(100, size(distmatx, 1));
  set(gca, 'FontUnit', 'normalized', 'FontSize', 1/num_rows);
end
