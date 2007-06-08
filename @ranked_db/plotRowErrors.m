function a_plot = plotRowErrors(a_ranked_db, rows, title_str, props)

% plotRowErrors - Create plot of rankings with errors associated with each measure color-coded.
%
% Usage:
% a_plot = plotRowErrors(a_ranked_db, rows, props)
%
% Description:
%
%   Parameters:
%	a_ranked_db: A ranked_db object.
%	rows: Indices of rows in a_ranked_db.
%	title_str: (Optional) String to append to plot title.
%	props: A structure with any optional properties.
%	  sortMeasures: If specified, measure order is determined with increasing 
%		overall distance.
%	  RowName: Label to show on X-axis (default='Ranks')
%	  rowSteps: Steps to jump in labeling rows on the x-axis.
% 	  superposeDistances: Superpose a white-colored distance line plot.
%	  (rest passed to plot_abstract)
%		
%   Returns:
%	a_plot: A plot_abstract object.
%
% See also: ranked_db, tests_db/rankMatching, plot_abstract, plotImage
%
% $Id$
%
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
joined_db = joinOriginal(a_ranked_db, rows);
joined_data = joined_db.data;

%# Ignore NeuronId?
crit_cols = fieldnames(a_ranked_db.crit_db.col_idx);
all_test_cols(1:length(crit_cols)) = true(1);
if isa(a_ranked_db.crit_db, 'params_tests_db')
  all_test_cols(1:get(a_ranked_db.crit_db, 'num_params')) = false;
end

%# The distance values for each individual measure has the same names in ranked_db
%# Find columns in ranked_db that are also in joined_db except 'Distance'
common_cols = setdiff(intersect(fieldnames(joined_db.col_idx), ...
				fieldnames(get(a_ranked_db, 'col_idx'))), ...
		      {'Distance', 'RowIndex'});

num_std_colors = 10; %# colors for one STD of variance
num_rows = dbsize(joined_db, 1);

%# Sanity check
if num_rows > 500
  error('Too many rows to display!');
end

%# Get matrix of desired rows and columns
only_ranked_rows_db = onlyRowsTests(a_ranked_db, 1:num_rows, common_cols);
distmatx = (abs(get(only_ranked_rows_db, 'data')) * num_std_colors)';

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

if isfield(props, 'quiet') || isfield(get(a_ranked_db, 'props'), 'quiet')
  if ~ isempty(title_str)
    the_title = title_str;
  end
else
  the_title = ['Per-measure errors in ranking ' ...
	       properTeXLabel(get(a_ranked_db, 'id')) title_str ];
end

if isfield(props, 'RowName')
  row_name = props.RowName;
else
  row_name = 'Ranks';
end

a_plot = plot_abstract({distmatx, num_std_colors}, {row_name, 'Measures'}, ...
		       the_title, {}, @plot_image, mergeStructs(props, ...
                                                  plot_props));

% 'border', [0.2 0.104 0.05 0.0903], 

if isfield(props, 'superposeDistances')
  a_plot = ...
      plot_inset({a_plot, ...
                     plotXRows(joined_db(1:num_rows, :), 'Distance', '', '', ...
                               struct('LineStyle', '-y', 'quiet', 1, 'tightLimits', 1, ...
                                      'noXLabel', 1, 'numXTicks', 0, ...
                                      'noTitle', 1, ...
                                      'axisProps', ...
                                      struct('Color', 'none', 'YAxisLocation', 'right'), ...
                                      'plotProps', struct('Color', [1 1 1], 'LineWidth', 3)))}, ...
                    [0 0 0.95 1; 0 0 1 1], title_str, mergeStructs(struct('noTitle', 1), ...
                                                    props));
end

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
