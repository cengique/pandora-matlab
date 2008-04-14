function a_bar_plot = plotUniquesStatsBars(a_db, unique_test, stat_test, title_str, props)

% plotUniquesStatsBars - Creates a mean-STD bar plot of a column for unique values of another column.
%
% Usage:
% a_bar_plot = plotUniquesStatsBars(a_db, unique_test, stat_test, title_str, props)
%
% Parameters:
%   a_db: A tests_db.
%   unique_test: Column for which to generate bars for each of its unique values.
%   stat_test: Column for which statsMeanSTD will be calculated for each bar.
%   props: A structure with any optional properties.
%	popMean: If specified, plot a dotted line specifying the
%		population mean. If NaN, calculated from a_db.
% 	yLims: two-element vector for specifying y axis limits showing
% 		interesting part of the bar plot.
% 	(rest passed to plot_bars [and plot_superpose if popMean]).
%		
% Description:
%
%   Returns:
%	a_bar_plot: A plot_abstract object to be plotted.
%
% Example:
% >> plotFigure(plotUniquesStatsBars(triplet_param_success_db, 'F_tau_m', ...
%                                'successDefault', 'across triplets', ...
%                                struct('fixedSize', [4 2], 'yLims', [.7 .9], ...
%                                       'popMean', 0.82, 'quiet', 1)))
%
% See also: tests_db, sortedUniqueValues, statsMeanStd, plot_bars
%
% $Id: plotUniquesStatsBars.m 858 2007-11-29 21:47:47Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2008/04/14

if ~ exist('props', 'var')
  props = struct;
end

if ~ exist('title_str', 'var')
  title_str = '';
end

% keep only columns we care about
a_db = onlyRowsTests(a_db, ':', {unique_test, stat_test});

% find unique values of column
sorted_unique_vals = ...
    sortedUniqueValues(get(sortrows(onlyRowsTests(a_db, ':', unique_test), ...
                                    unique_test), 'data'));

% get stats for first unique value
a_stats_db = ...
    statsMeanStd(onlyRowsTests(a_db, ...
                               onlyRowsTests(a_db, ':', unique_test) == ...
                 sorted_unique_vals(1), ':'));
  
for unique_num = 2:length(sorted_unique_vals)
  a_stats_db = ...
      compareStats(a_stats_db, ...
                   statsMeanStd(onlyRowsTests(a_db, ...
                                              onlyRowsTests(a_db, ':', unique_test) == ...
                                              sorted_unique_vals(unique_num), ':')));
end

if isfield(props, 'quiet')
  all_title = properTeXLabel(title_str);
else
  all_title = ...
      properTeXLabel([lower(get(a_db, 'id')) title_str ]);
end

if isfield(props, 'yLims')
  props.axisLimits = [NaN NaN props.yLims];
end


a_bar_plot = ...
    plot_bars(a_stats_db, all_title, ...
              mergeStructs(props, struct('pageVariable', unique_test, 'quiet', 1, ...
                                         'tightLimits', 1, 'grid', 1))); %
  
% draw a dotted line showing population mean
if isfield(props, 'popMean')
  pop_mean = props.popMean;
  if isnan(pop_mean)
    pop_stats_db = statsMeanStd(onlyRowsTests(a_db, ':', stat_test));
    pop_mean = ...
        get(onlyRowsTests(pop_stats_db, 'mean', stat_test), 'data');
  end

  a_line_plot = ...
      plot_abstract({[1 length(sorted_unique_vals) ], ...
                     [ pop_mean, pop_mean ], ...
                     ':', 'Color', [.3 .3 .3], 'LineWidth', 3}, {}, '', ...
                    {}, 'plot');
  a_bar_plot = ...
      plot_superpose({a_bar_plot, a_line_plot }, {}, ' ', ...
                     mergeStructs(props, struct('tightLimits', 0, 'noLegends', 1)));
end
