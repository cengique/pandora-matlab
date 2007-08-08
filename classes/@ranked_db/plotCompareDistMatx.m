function a_plot = ...
      plotCompareDistMatx(db, w_db, rows, col_size, col_name, num_col_labels, ...
			  row_name, num_row_labels, title_str, props)

% plotCompareDistMatx - Compare differences and correlations of distance matrices from two ranked DBs.
%
% Usage:
% a_plot = plotCompareDistMatx(db, rows, col_size, col_name, num_col_labels, 
%			  row_name, num_row_labels, title_str, props)
%
% Description:
%   Produces three plots: (1) distance difference matrix, (2) 2D cross-correlogram, 
% and (3) repeated 1D cross-correlogram for each row.
%
%   Parameters:
%	db, w_db: The ranked_db objects to be compared.
%	rows: Indices of rows in db after joining (and sorting) for both DBs.
%	col_size: Number of rows to take from DB to form the columns of matrix plot.
%	col_name, row_name: DB column to use fot the figure column and row, respectively.
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
% See also: tests_db, plot_abstract
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/12/12

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

if ~ exist('props')
  props = struct;
end

%# Assume both DBs identically organized (!)
[dmatx1 joined_db] = getDistMatrix(db, rows, col_size, props); 
dmatx2 = getDistMatrix(w_db, rows, col_size, props); 

num_plot_rows = size(dmatx1, 1);

%# General plot properties
plot_props = struct('border', 0.2);

%# Create tick labels from DB contents
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
  title_str = [ strrep(get(db, 'id'), '_', ' ') ];
end


num_colors = 50;

%# Distance difference
dsub = dmatx2 - dmatx1;

a_plot(1) = ...
    plot_abstract({dsub * num_colors / max(max(abs(dsub))) + num_colors, @pmcolors, ...
		   2*num_colors, props}, ...
		  {col_name, row_name}, 'Distance difference matrix', ...
		  {}, @plot_image, mergeStructs(props, plot_props));

%# 1D correlogram for each row

for row_num=1:size(dmatx1, 1); 
  row_vector = xcorr(1 ./ dmatx2(row_num, :), 1 ./ dmatx1(row_num, :), 'unbiased'); 
  %# Normalize
  dcorr1dr(row_num, :) = row_vector ./ max(row_vector);
end

%# Create cross-correlogram tick labels for x-axis
xticks = sort(col_size:-2*col_size/num_col_labels:1);
plot_props.XTick = [ xticks, (2* col_size - xticks((length(xticks) - 1):-1:1))];
for label_num = 1:length(plot_props.XTick)
  col_labels{label_num} = ...
      sprintf('%+d', floor(plot_props.XTick(label_num)) - col_size);
end
plot_props.XTickLabel = col_labels;

a_plot(2) = ...
    plot_abstract({dcorr1dr * num_colors, @jet, num_colors, props}, ...
		  {[col_name ', center='], row_name}, '1D cross-correlogram for each row', ...
		  {}, @plot_image, mergeStructs(props, plot_props));

%# 2D correlogram
dcorr2 = ...
    xcorr2(1./dmatx2, 1./dmatx1(6:15,6:15)) ./ ...
    (calcUnbiasMatx(num_plot_rows*3/4, col_size*3/4) .^ 1);

%# Create cross-correlogram tick labels for y-axis
yticks = sort(num_plot_rows:-2*num_plot_rows/num_row_labels:1);
plot_props.YTick = [ yticks, (2* num_plot_rows - yticks((length(yticks) - 1):-1:1))];
for label_num = 1:length(plot_props.YTick)
  row_labels{label_num} = ...
      sprintf('%+d', floor(plot_props.YTick(label_num)) - num_plot_rows);
end
plot_props.YTickLabel = row_labels;

a_plot(3) = ...
    plot_abstract({dcorr2 * num_colors / max(max(dcorr2)), @jet, num_colors, props}, ...
		  {col_name, row_name}, '2D cross-correlogram', ...
		  {}, @plot_image, mergeStructs(props, plot_props));
end

%# Small function for creating matrix plot
function h = plot_image(distmatx, colormap_func, num_colors, props)
  h = image(distmatx);
  %# Show up to some number of STDs
  colormap(gca, feval(colormap_func, num_colors)); 
  if isfield(props, 'colorbar')
    colorbar;
  end
  %# scale font to fit measure names on y-axis
  num_rows = max(100, size(distmatx, 1));
  %#set(gca, 'FontUnit', 'normalized', 'FontSize', 1/num_rows);
end

function unbias_matx = calcUnbiasMatx(num_rows1, num_cols1, num_rows2, num_cols2)
  diff_rows = abs(num_rows2 - num_rows1);
  diff_cols = abs(num_cols2 - num_cols1);
  num_rows = num_rows1 + num_rows2 - diff_rows;
  num_cols = num_cols1 + num_cols2 - diff_cols;
  counter = ones(num_rows,1)*(1:num_cols); 
  countert = ones(num_cols,1)*(1:num_rows); 
  quart = counter .* countert'; 
  unbias_matx = [quart, quart(:, (num_cols - 1):-1:1); ...
		 quart((num_rows - 1):-1:1, :), quart((num_rows - 1):-1:1, (num_cols - 1):-1:1)];
end

%# Make colormap with num_colors, where num_colors/2 point to a zero-crossing
function colors = pmcolors(num_colors)
  num_half_colors = floor(num_colors / 2);
  colors = [((num_half_colors:-1:1)' *[0 0 1/num_half_colors]); ...
	    ((1:num_half_colors)' *[1/num_half_colors 0 0])];
end
