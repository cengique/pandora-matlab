function an_image_plot = plotUniquesStats2D(a_db, unique_test1, unique_test2, ...
                                            stat_test, title_str, props)

% plotUniquesStats2D - 2D image plot of the change in column mean for unique values of two other columns.
%
% Usage:
% an_image_plot = plotUniquesStats2D(a_db, unique_test1, unique_test2, 
% 					stat_test, title_str, props)
%
% Parameters:
%   a_db: A tests_db.
%   unique_test1, unique_test2: Columns whose unique values make up the X
%   		& Y of the 2D image plot.
%   stat_test: Column for which statsMeanSTD will be calculated for each
%   		unique value.
%   props: A structure with any optional properties.
%	popMean: If specified, plot a dotted line specifying the
%		population mean. If NaN, calculate from given a_db.
%	popDev: Use this value +/- to choose colorbar extents
%		(default=.3 or 2*STD if popMean=NaN).
%	colorbar: Show vertical colorbar axis (see plotImage).
%	uniqueVals1,uniqueVals2: Use these unique values for
%			unique_test1,unique_test2.
%	statsFunc: tests_db/stats* method to use (default: statsMeanStd).
%	statsRow: The row to pick from statsFunc results (default: mean).
% 	(rest passed to plotImage and plot_abstract).
% 
% Description:
%
% Returns:
%	an_image_plot: A plot_abstract object to be plotted.
%
% Example:
% >> plotFigure(plotUniquesStats2D(triplet_param_success_db, ...
%               'F_tau_m', 'S_tau_m', 'successDefault', ...
% 	 	'accross triplets', 
% 		struct('fixedSize', [4 3], 'popMean', NaN, ...
%		'colorbar', 1, 'quiet', 1, 'border', [0.03 0 0.03 0])))
%
% See also: tests_db, sortedUniqueValues, statsMeanStd, plot_abstract, plotImage
%
% $Id: plotUniquesStats2D.m 858 2007-11-29 21:47:47Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2008/04/14

  if ~ exist('props', 'var')
  props = struct;
end

if ~ exist('title_str', 'var')
  title_str = '';
end

% keep only columns we care about
a_db = onlyRowsTests(a_db, ':', {unique_test1, unique_test2, stat_test});

% find unique values of both columns
if isfield(props, 'uniqueVals1')
  sorted_unique_vals1 = props.uniqueVals1;
else
  sorted_unique_vals1 = ...
      sortedUniqueValues(get(sortrows(onlyRowsTests(a_db, ':', unique_test1), ...
                                      unique_test1), 'data'));
end

if isfield(props, 'uniqueVals2')
  sorted_unique_vals2 = props.uniqueVals2;
else
  sorted_unique_vals2 = ...
      sortedUniqueValues(get(sortrows(onlyRowsTests(a_db, ':', unique_test2), ...
                                      unique_test2), 'data'));
end

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

% find population mean and deviation if requested
if isfield(props, 'popMean')
  pop_mean = props.popMean;
  if isnan(props.popMean)
    pop_stats_db = feval(stats_func, onlyRowsTests(a_db, ':', stat_test));
    if strcmp(stats_func, 'statsMeanStd')
      pop_mean = ...
          get(onlyRowsTests(pop_stats_db, stats_row, stat_test), 'data');
      pop_dev = ...
          2*get(onlyRowsTests(pop_stats_db, 'STD', stat_test), 'data');
    elseif strcmp(stats_func, 'statsBounds')
      max_val = ...
          get(onlyRowsTests(pop_stats_db, 'max', stat_test), 'data');
      mean_val = ...
          get(onlyRowsTests(pop_stats_db, 'mean', stat_test), 'data');
      pop_mean = ...
          mean_val + (max_val - mean_val) / 2;
      pop_dev = ...
        (max_val - mean_val) / 2;
    end
      
  end
else
  pop_mean = 0;
end

if isfield(props, 'popDev')
  pop_dev = props.popDev;
elseif ~ exist('pop_dev', 'var')
  pop_dev = 0.3;
end

% first find unique values of each variable
% roll across left and right uniques
num_left_uniques = length(sorted_unique_vals1);
num_right_uniques = length(sorted_unique_vals2);

stats_matx = repmat(NaN, num_left_uniques, num_right_uniques);

for left_val_num = 1:num_left_uniques
  left_idx = ...
      onlyRowsTests(a_db, ':', unique_test1) == ...
      sorted_unique_vals1(left_val_num);

  for right_val_num = 1:num_right_uniques
    right_idx = ...
        onlyRowsTests(a_db, ':', unique_test2) == ...
        sorted_unique_vals2(right_val_num);
    
    % calculate stats for joint condition
    
    a_stats_db = ...
        feval(stats_func, onlyRowsTests(a_db, left_idx & right_idx, stat_test));

    % use only desired row
    stats_matx(left_val_num, right_val_num) = ...
        get(onlyRowsTests(a_stats_db, stats_row, stat_test), 'data');
  end
end

% col names
left_var_name = getColNames(a_db, unique_test1);
left_var_name = left_var_name{1};
right_var_name = getColNames(a_db, unique_test2);
right_var_name = right_var_name{1};

% title
if isfield(props, 'quiet')
  all_title = properTeXLabel(title_str);
else
  all_title = ...
      properTeXLabel([lower(get(a_db, 'id')) title_str ]);
end

% plot image here
num_colors = 50;

% set x/y axis ticks
plot_props.XTick = 1:num_right_uniques;
plot_props.XTickLabel = sorted_unique_vals2;
plot_props.YTick = 1:num_left_uniques;
plot_props.YTickLabel = sorted_unique_vals1;

% colorbar props
image_props = struct;
image_props.colorbarProps = struct;
image_props.colorbarProps.YTick = ...
    [1, num_colors + 1, 2*num_colors];
image_props.colorbarProps.YTickLabel = ...
    pop_mean + [ - pop_dev, 0, pop_dev];
image_props.colorbarLabel = getColNames(a_db, stat_test);
image_props.truncateDecDigits = 2;

an_image_plot = ...
    plot_image((stats_matx - pop_mean) ./ pop_dev * num_colors + num_colors, ...
               [1 1 1; colormapBlueCrossRed(num_colors)], ...
               num_colors, ...
               { properTeXLabel(right_var_name), ...
                 properTeXLabel(left_var_name) }, ...
               all_title, ...
               mergeStructs(mergeStructs(props, plot_props), image_props));
