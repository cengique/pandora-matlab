function a_plot = plotRowMatrix(hist_dbs, title_str, props)

% plotRowMatrix - Generates a subplot matrix of measure columns versus rows of databases. 
%
% Usage:
% a_plot = plotRowMatrix(hist_dbs, title_str, props)
%
% Description:
%   Each row in the hist_dbs is assumed to come from a different DB. Columns represent histograms 
% of different measurements. The plot is made such that histograms in each row have the same
% maximal count, and histograms in each column have the same axis limits.
%
%   Parameters:
%	hist_dbs: A matrix of histogram_db objects.
%	title_str: Title to go at the top.
%	props: A structure with any optional properties.
%	  rowLabels: Cell array of y-axis labels for each row.
%	  (rest passed to histogram_db/plot_abstract)
%		
%   Returns:
%	a_plot: A object of plot_abstract or one of its subclasses.
%
% See also: plot_abstract
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/11/22

%# Get plot_abstract objects
all_plots = plot_abstract(hist_dbs, '', props);

num_rows = size(hist_dbs, 1);
num_cols = size(hist_dbs, 2);

%# 1st pass: Set maximal count ranges for each row
maximal_count = zeros(num_rows, 1);
for row_num=1:num_rows
  %# For each column
  row_ranges = [];
  for col_num=1:num_cols
    row_ranges = growRange([ row_ranges; axis(all_plots(row_num, col_num)) ]);
    if col_num == 1 && isfield(props, 'rowLabels')
      %# set the row label if requested
      header_plot = all_plots(row_num, col_num);
      header_plot.axis_labels{2} = props.rowLabels{row_num};
      all_plots(row_num, col_num) = header_plot;
    end
  end
  maximal_count(row_num) = row_ranges(4);
end

%# 2nd pass: Set x-axis limits for each column
axis_limits = zeros(num_cols, 2);
for col_num=1:num_cols
  %# For each column
  col_ranges = [];
  for row_num=1:num_rows
    col_ranges = growRange([ col_ranges; axis(all_plots(row_num, col_num)) ]);
  end
  axis_limits(col_num, :) = col_ranges(1:2);
end

%# 3rd pass: Assign the calculated limits and produce the stacked plot
row_plots(1:num_rows) = plot_stack;
for row_num=1:num_rows
  %# For each column
  row_ranges = [];
  for col_num=1:num_cols
    %# set the xy ranges to each plot
    all_plots(row_num, col_num) = ...
	set(all_plots(row_num, col_num), 'props', ...
	    mergeStructs(props, struct('axisLimits', [axis_limits(col_num, :) 0 maximal_count(row_num)])));
  end
  row_plots(row_num) = ...
      plot_stack(num2cell(all_plots(row_num, :)), [], 'x', '', ...
		 struct('titlesPos', 'none', 'yLabelsPos', 'left', 'yTicksPos', 'left'));
end

%# final y-stack plot
a_plot = plot_stack(num2cell(row_plots), [], 'y', title_str, ...
		    mergeStructs(props, struct('xLabelsPos', 'bottom', 'xTicksPos', 'bottom', 'titlesPos', 'none')));