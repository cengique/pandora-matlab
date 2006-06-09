function a_plot = plotColorSumVar(p_stats, title_str, props)

% plotColorVar - Create a color-plot of parameter-test variations in a matrix.
%
% Usage:
% a_plot = plotColorVar(p_stats, props)
%
% Description:
%   Skips the 'ItemIndex' test.
%
% Parameters:
%	p_stats: Array of invariant parameter databases obtained from
%		calling tests_3D_db/paramsTestsHistsStats.
%	title_str: (Optional) String to append to plot title.
%	props: A structure with any optional properties, passed to plot_stack.
%	  plotMethod: 'plotVar' uses stats_db/plotVar (default)
%		      'plot_bars' uses stats_db/plot_bars
%		
% Returns:
%	a_plot: A plot_abstract with the color plot
%
% See also: paramsTestsHistsStats, params_tests_profile, plotVar.
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/17

if ~ exist('props')
  props = struct([]);
end

num_params = length(p_stats);
num_tests = dbsize(p_stats(1), 2) - 2; %# Subtract param and RowIndex columns

image_data = zeros(num_tests, num_params);
for param_num=1:num_params
  image_data(1:num_tests, param_num) = ...
      transpose(get(sum(swapRowsPages(onlyRowsTests(p_stats(param_num), ...
						    1, 2:(1+num_tests), ':'))), 'data'));
end

%# normalize each test row
image_data = image_data ./ (max(abs(image_data), [], 2) * ones(1, size(image_data, 2)));

num_colors = 49;
num_plot_rows = size(image_data, 1);

plot_props = struct('border', 0.05);

plot_props.YTick = 1:num_tests;
row_labels = properTeXLabel(getColNames(p_stats(1), 2:(1+num_tests)));
plot_props.YTickLabel = row_labels;

plot_props.XTick = 1:num_params;
for param_num = 1:num_params
  a_cell = getColNames(p_stats(param_num), 1);
  col_labels{param_num} = a_cell{1};
end
plot_props.XTickLabel = properTeXLabel(col_labels);

if ~ exist('title_str') || isempty(title_str)
  title_str = ['Summed matrix of ' lower(strrep(get(p_stats(1), 'id'), '_', ' ')) ];
end

a_plot = plot_abstract({image_data * num_colors + num_colors, @colormapBlueCrossRed, ...
			num_colors, props}, {}, ...
		       title_str, {}, @plot_image, mergeStructs(props, plot_props));
end

%# Small function for creating matrix plot
function h = plot_image(image_data, colormap_func, num_colors, props)
  h = image(image_data);
  %# Show up to some number of STDs
  colormap(feval(colormap_func, num_colors)); 
  if isfield(props, 'colorbar')
    hc = colorbar;
    set(hc, 'YTick', [1, (num_colors + 1),  (2 * num_colors + 1)]);
    set(hc, 'YTickLabel', [-1, 0, +1]);
  end
  %# scale font to fit measure names on y-axis
  num_rows = max(100, size(image_data, 1));
  %#set(gca, 'FontUnit', 'normalized', 'FontSize', 1/num_rows);
end

