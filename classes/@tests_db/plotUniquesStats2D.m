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
% 	(rest passed to plotImage and plot_abstract).
% 
% Description:
%
% Returns:
%	an_image_plot: A plot_abstract object to be plotted.
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
sorted_unique_vals1 = ...
    sortedUniqueValues(get(sortrows(onlyRowsTests(a_db, ':', unique_test1), ...
                                    unique_test1), 'data'));

sorted_unique_vals2 = ...
    sortedUniqueValues(get(sortrows(onlyRowsTests(a_db, ':', unique_test2), ...
                                    unique_test2), 'data'));

% first find unique values of each variable

if isfield(props, 'popMean')
  pop_mean = props.popMean;
  if isnan(pop_mean)
    pop_stats_db = statsMeanStd(onlyRowsTests(a_db, ':', stat_test));
    pop_mean = ...
        get(onlyRowsTests(pop_stats_db, 'mean', stat_test), 'data');
    pop_dev = ...
        2*get(onlyRowsTests(pop_stats_db, 'STD', stat_test), 'data');
  end
else
  pop_mean = 0;
end

if isfield(props, 'popDev')
  pop_dev = props.popDev;
elseif ~ exist('pop_dev', 'var')
  pop_dev = 0.3;
end

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
        statsMeanStd(onlyRowsTests(a_db, left_idx & right_idx, stat_test));

    % use only mean
    stats_matx(left_val_num, right_val_num) = ...
        get(onlyRowsTests(a_stats_db, 'mean', stat_test), 'data');
  end
end

% col names
left_var_name = getColNames(a_db, unique_test1);
right_var_name = getColNames(a_db, unique_test2);

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
    1 + (0:num_colors:(2*num_colors - 1));
image_props.colorbarProps.YTickLabel = ...
    pop_mean + [ - pop_dev, 0, pop_dev];
image_props.colorbarLabel = getColNames(a_db, stat_test);
image_props.truncateDecDigits = 2;

an_image_plot = ...
    plot_abstract({(stats_matx - pop_mean) ./ pop_dev * num_colors + num_colors, ...
                   [1 1 1; colormapBlueCrossRed(num_colors)], ...
                   num_colors, mergeStructs(props, image_props)}, ...
                  { properTeXLabel(right_var_name), ...
                    properTeXLabel(left_var_name) }, ...
                  all_title, {}, @plotImage, mergeStructs(props, plot_props));
