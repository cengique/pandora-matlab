function a_plot = ...
      plotDistMatrix(db, rows, col_size, col_name, num_col_labels, ...
		     row_name, num_row_labels, title_str, props)

% plotDistMatrix - Create a color-coded matrix plot of with total errors from the ranked DB.
%
% Usage:
% a_plot = plotDistMatrix(db, rows, col_size, col_name, num_col_labels, 
%			  row_name, num_row_labels, title_str, props)
%
% Description:
%   The col_size parameter is used to find the number of rows that make up the 
% x-dimension of the color matrix plot.
%
%   Parameters:
%	db: A ranked_db object.
%	rows: Indices of rows in db after joining (and sorting).
%	col_size: Number of rows to take from DB to form the columns of matrix plot.
%	col_name, row_name: DB column to use for the figure column and row, respectively.
%	num_col_labels, num_row_labels: Number of labels to put on each axis.
%	title_str: If non-empty, replaces generic title with db name. 
%	props: A structure with any optional properties.
%	  sortBy: If specified, db is sorted after being joined with original using this column.
%	  colorbar: Put a colorbar on the figure.
%	  (also passed to plot_abstract)
%		
%   Returns:
%	a_plot: A plot_abstract object.
%
% Example:
% >> plotFigure(plotDistMatrix(scored_blocked_sk_gps0503b_control_db, ':', 10, 'SK', 10, 'trial', 10, 'gps0503b (control), preset 6 - top 50 matches', struct('sortBy', 'trial', 'colorbar', 1, 'PaperPosition', [0 0 5 3])));
%
% See also: ranked_db, plot_abstract, getDistMatrix, plotCompareDistMatx
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/12/12

if ~ exist('props')
  props = struct;
end

num_colors = 50;
[distmatx joined_db] = getDistMatrix(db, rows, col_size, props); 

num_plot_rows = size(distmatx, 1);

plot_props = struct('border', 0.2);

plot_props.YTick = 1:num_plot_rows/num_row_labels:num_plot_rows;
for label_num = 1:num_row_labels
  row_labels{label_num} = ...
      sprintf('%.2f', joined_db(floor(plot_props.YTick(label_num) * col_size), row_name).data);
end
plot_props.YTickLabel = row_labels;

plot_props.XTick = 1:col_size/num_col_labels:col_size;
for label_num = 1:num_col_labels
  col_labels{label_num} = ...
      sprintf('%.2f', joined_db(floor(plot_props.XTick(label_num)), col_name).data);
end

plot_props.XTickLabel = col_labels;

if ~ exist('title_str') || isempty(title_str)
  title_str = ['Total distances ' strrep(get(db, 'id'), '_', ' ') ];
end

a_plot = plot_abstract({distmatx * num_colors / 5, num_colors, 'hot', props}, {col_name, row_name}, ...
		       title_str, {}, @plot_image, mergeStructs(props, plot_props));
end

%# Small function for creating matrix plot
function h = plot_image(distmatx, num_colors, colormap_func, props)
  h = image(distmatx);
  %# Show up to some number of STDs
  colormap(feval(colormap_func, num_colors)); 
  if isfield(props, 'colorbar')
    colorbar;
  end
  %# scale font to fit measure names on y-axis
  num_rows = max(100, size(distmatx, 1));
  %#set(gca, 'FontUnit', 'normalized', 'FontSize', 1/num_rows);
end
