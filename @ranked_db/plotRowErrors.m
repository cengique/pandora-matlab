function a_plot = plotRowErrors(db, rows, title_str, props)

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
%	title_str: (Optional) String to append to plot title.
%	props: A structure with any optional properties.
%	  sortMeasures: If specified, measure order is determined with increasing 
%		overall distance.
%	  rowSteps: Steps to jump in labeling rows on the x-axis.
%	  (rest passed to plot_abstract)
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

if ~ exist('title_str')
  title_str = '';
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

size(distmatx)

%# Replace NaNs in distmatx with 3 STD
distmatx(isnan(distmatx)) = 3 * num_std_colors;

if isfield(props, 'sortMeasures')
  [a sorted_idx] = sortrows(sum(distmatx, 2));
  distmatx = distmatx(sorted_idx, :);
  common_cols = common_cols(sorted_idx);
end

if isfield(props, 'rowSteps')
  row_steps = props.rowSteps;
else
  row_steps = 1;
end
plot_props = struct('XTick', 1:row_steps:num_rows, 'YTick', 1:length(common_cols), 'border', [0.07 0 0 0]);
plot_props.YTickLabel = properTeXLabel(common_cols);

if isfield(props, 'quiet') || isfield(get(db, 'props'), 'quiet')
  if ~ isempty(title_str)
    the_title = title_str;
  end
else
  the_title = ['Per-measure errors in ranking ' ...
	       properTeXLabel(get(db, 'id')) title_str ];
end

a_plot = plot_abstract({distmatx, num_std_colors}, {'Ranks', 'Measures'}, ...
		       the_title, {}, @plot_image, mergeStructs(props, plot_props));
end

%# Small function for creating matrix plot
function h = plot_image(distmatx, num_std_colors)
  h = image(distmatx);
  %# Show up to some number of STDs
  colormap(jet(3 * num_std_colors)); 
  %# scale font to fit measure names on y-axis
  num_rows = size(distmatx, 1);
  if num_rows > 30
    set(gca, 'FontUnit', 'normalized', 'FontSize', 1/max(100, num_rows));
  end
end
