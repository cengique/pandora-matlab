function a_plot_stack = plotVarMatrix(a_db, p_stats, props)

% plotVarMatrix - Create a stack of parameter-test variation plots organized in a matrix.
%
% Usage:
% a_plot_stack = plotVarMatrix(a_db, p_stats, props)
%
% Description:
%   Skips the 'ItemIndex' test.
%
%   Parameters:
%	a_db: A params_tests_db object.
%	p_stats: Cell array of invariant parameter databases obtained from
%		calling paramsTestsHistsStats.
%	props: A structure with any optional properties, passed to plot_stack.
%	  plotMethod: 'plotVar' uses stats_db/plotVar (default)
%		      'plot_bars' uses stats_db/plot_bars
%		
%   Returns:
%	a_plot_stack: A plot_stack with the plots organized in matrix form
%
% See also: paramsTestsHistsStats, params_tests_profile, plotVar.
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/17

%# TODO: use only p_stats, guess num_params by number of pages

if ~ exist('props')
  props = struct([]);
end

num_params = a_db.num_params;
num_tests = dbsize(a_db, 2) - num_params; %# Except the item indices

%# TODO: Row stacks with 
plot_rows = cell(1, num_tests);
for test_num=1:num_tests

  plots = cell(1, num_params);  
  ranges = [];
  for param_num=1:num_params
    a_stats_db = p_stats{param_num};
    if isfield(props, 'plotMethod') && strcmp(props.plotMethod, 'plot_bars')
      row_props = struct;
      if param_num > 1
	row_props = struct('noYLabel', 1, 'YTickLabel', []);
      end
      if test_num < num_tests
	row_props = mergeStructs(struct('noXLabel', 1, 'XTickLabel', []), row_props);
      end
      a_plot = ...
	  plot_bars(onlyRowsTests(p_stats{param_num}, ':', [1, test_num + 1], ':'), ...
		    '', mergeStructs(row_props, ...
				     struct('dispNvals', 0, 'pageVariable', 1, ...
					    'rotateYLabel', 60, 'truncateDecDigits', 2)));
      axis_ranges = axis(a_plot.plot_stack.plots{1});
    else
      a_plot = plotVar(p_stats{param_num}, 1, test_num + 1, ...
		       struct('rotateYLabel', 60));
      %# Calculate the maximal axis range
      axis_ranges = axis(a_plot);
    end

    if isempty(ranges)
      ranges = axis_ranges;
    else
      ranges = growRange([ranges; axis_ranges]);
    end

    plots{param_num} = setProp(a_plot, 'tightLimits', 1);
  end
  if test_num == num_tests
    horiz_props = struct('titlesPos', 'none', ...
			 'yLabelsPos', 'left', ...
			 'yTicksPos', 'left');
  else
    horiz_props = struct('titlesPos', 'none', ...
			 'yLabelsPos', 'left', ...
			 'yTicksPos', 'left', ...
			 'xLabelsPos', 'none', ...
			 'xTicksPos', 'none');
  end

  %# fixed y-axis bounds, but flexible x-axis
  plot_rows{test_num} = plot_stack(plots, [NaN NaN ranges(3:4)], 'x', '', horiz_props);
end

title_str = [ p_stats{1}.id ];
%# 'Measure Variations with Parameter Values'

a_plot_stack = plot_stack(plot_rows, [], 'y', ...
			  title_str, ...
			  mergeStructs(props, struct('titlesPos', 'none', ...
						     'xLabelsPos', 'bottom', ...
						     'xTicksPos', 'bottom')));
