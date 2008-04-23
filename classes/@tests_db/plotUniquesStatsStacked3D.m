function a_stacked_plot = ...
      plotUniquesStatsStacked3D(a_db, unique_test1, unique_test2, ...
                                unique_test3, stat_test, title_str, props)

% plotUniquesStatsStacked3D - Stack of 2D image plots of a column mean at unique values of three other columns.
%
% Usage:
% a_stacked_plot = plotUniquesStatsStacked3D(a_db, unique_test1, unique_test2, 
% 					unique_test3, stat_test, title_str, props)
%
% Parameters:
%   a_db: A tests_db.
%   unique_test1, unique_test2: Columns whose unique values make up the X
%   		& Y of the 2D image plot.
%   unique_test3: Column whose unique values make up stacked dimension.
%   stat_test: Column for which statsMeanSTD will be calculated for each
%   		unique value.
%   props: A structure with any optional properties.
% 	(rest passed to plotUniquesStats2D and plot_stack).
% 
% Description:
%
% Returns:
%	a_stacked_plot: A plot_abstract object to be plotted.
%
% See also: tests_db, sortedUniqueValues, statsMeanStd, plot_abstract, plotImage
%
% $Id: plotUniquesStatsStacked3D.m 858 2007-11-29 21:47:47Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2008/04/15

  if ~ exist('props', 'var')
  props = struct;
end

if ~ exist('title_str', 'var')
  title_str = '';
end

% keep only columns we care about
a_db = onlyRowsTests(a_db, ':', {unique_test1, unique_test2, unique_test3, ...
                    stat_test});

% find unique values of all columns
sorted_unique_vals1 = ...
    sortedUniqueValues(get(sortrows(onlyRowsTests(a_db, ':', unique_test1), ...
                                    unique_test1), 'data'));
sorted_unique_vals2 = ...
    sortedUniqueValues(get(sortrows(onlyRowsTests(a_db, ':', unique_test2), ...
                                    unique_test2), 'data'));
sorted_unique_vals3 = ...
    sortedUniqueValues(get(sortrows(onlyRowsTests(a_db, ':', unique_test3), ...
                                    unique_test3), 'data'));

num_stack_uniques = length(sorted_unique_vals3);

stack_var_name = getColNames(onlyRowsTests(a_db, ':', unique_test3));
stack_var_name = properTeXLabel(stack_var_name{1});

% use given stats func
if isfield(props, 'statsFunc')
  stats_func = props.statsFunc;
else
  stats_func = 'statsMeanStd';
end

% use given stats row
if isfield(props, 'statsRow')
  stats_row = props.statsRow;
else
  stats_row = 'mean';
end

default_image_props = props;
default_image_props.uniqueVals1 = sorted_unique_vals1;
default_image_props.uniqueVals2 = sorted_unique_vals2;

% determine population mean and deviation to be used for all 2D plots
% consistently
if isfield(props, 'popMean')
  if isnan(props.popMean)
    pop_stats_db = feval(stats_func, onlyRowsTests(a_db, ':', stat_test));
    if strcmp(stats_func, 'statsMeanStd')
      default_image_props.popMean = ...
          get(onlyRowsTests(pop_stats_db, stats_row, stat_test), 'data');
      default_image_props.popDev = ...
          2*get(onlyRowsTests(pop_stats_db, 'STD', stat_test), 'data');
    elseif strcmp(stats_func, 'statsBounds')
      max_val = ...
          get(onlyRowsTests(pop_stats_db, 'max', stat_test), 'data');
      mean_val = ...
          get(onlyRowsTests(pop_stats_db, 'mean', stat_test), 'data');
      default_image_props.popMean = ...
          mean_val + (max_val - mean_val) / 2;
      default_image_props.popDev = ...
        (max_val - mean_val) / 2;
    end
      
  end
end

if isfield(props, 'quiet')
  default_image_props.quiet = props.quiet;
end

s_plots = {};
for stack_val_num = 1:num_stack_uniques
  stack_idx = ...
      onlyRowsTests(a_db, ':', unique_test3) == ...
      sorted_unique_vals3(stack_val_num);
  
  image_props = default_image_props;
  if isfield(props, 'colorbarPos') && strcmp(props.colorbarPos, 'right') ...
      && stack_val_num == num_stack_uniques
    image_props.colorbar = 1;
  end
  
  an_image_plot = ...
      plotUniquesStats2D(onlyRowsTests(a_db, stack_idx, ':'), unique_test1, ...
                         unique_test2, stat_test, '', ...
                         image_props);
  axis_labels = get(an_image_plot, 'axis_labels');
  s_plots = ...
      [ s_plots, ...
        { set(an_image_plot, 'axis_labels', ...
                    { [ axis_labels{1} ' (' stack_var_name '=' ...
                      num2str(sorted_unique_vals3(stack_val_num)) ')' ], ...
                      axis_labels{2} }) } ];
end

% title
if isfield(props, 'quiet')
  all_title = properTeXLabel(title_str);
else
  all_title = ...
      properTeXLabel([lower(get(a_db, 'id')) title_str ]);
end

% adjust relative sizes to give slack to last plot
if isfield(props, 'colorbarPos') && strcmp(props.colorbarPos, 'right')
  relative_sizes = ones(num_stack_uniques, 1);
  relative_sizes(end) = 1.3;
  props.relativeSizes = relative_sizes;  
end

% TODO: make orientation optional
a_stacked_plot = ...
    plot_stack(s_plots, [Inf Inf Inf Inf], 'x', '', ... % 
               mergeStructs(props, struct('yLabelsPos', 'left', 'yTicksPos', ...
                                          'left')))