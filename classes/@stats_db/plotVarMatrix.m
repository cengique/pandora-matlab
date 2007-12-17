function a_plot_stack = plotVarMatrix(p_stats, props)

% plotVarMatrix - Create a stack of parameter-test variation plots organized in a matrix.
%
% Usage:
% a_plot_stack = plotVarMatrix(p_stats, props)
%
% Description:
%   Skips the 'ItemIndex' test.
%
% Parameters:
%	p_stats: Array of invariant parameter databases obtained from
%		calling tests_3D_db/paramsTestsHistsStats.
%	props: A structure with any optional properties, passed to plot_stack.
%	  plotMethod: 'plotVar' uses stats_db/plotVar (default)
%		      'plot_bars' uses stats_db/plot_bars
%	  rotateYLabel: Rotate row labels this much (default=60).
%		
% Returns:
%	a_plot_stack: A plot_stack with the plots organized in matrix form
%
% See also: paramsTestsHistsStats, params_tests_profile, plotVar.
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/17

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props')
  props = struct([]);
end

if ~ isfield(props, 'rotateYLabel')
  rotate_labels = 60;
else
  rotate_labels = props.rotateYLabel;
end

num_params = length(p_stats);
num_tests = dbsize(p_stats(1), 2) - 2; % Subtract param and RowIndex columns

% TODO: Row stacks with 
plot_rows = cell(1, num_tests);
for test_num=1:num_tests

  plots = cell(1, num_params);  
  ranges = [];
  relativeSizes = ones(1, num_params);
  % Do all params in each plot row
  for param_num=1:num_params
    a_stats_db = p_stats(param_num);
    if isfield(props, 'plotMethod') && strcmp(props.plotMethod, 'plot_bars')
      row_props = struct;
      if param_num > 1
	row_props = struct('noYLabel', 1, 'YTickLabel', []);
      end
      if test_num < num_tests
	row_props = mergeStructs(struct('noXLabel', 1, 'XTickLabel', []), row_props);
      end
      a_plot = ...
	  plot_bars(onlyRowsTests(p_stats(param_num), ':', [1, test_num + 1], ':'), ...
		    '', mergeStructs(row_props, ...
				     struct('dispNvals', 0, 'pageVariable', 1, ...
					    'rotateYLabel', rotate_labels, ...
					    'truncateDecDigits', 1)));
      a_plot.plot_stack.plots{1}.props.tightLimits = 1;
      axis_ranges = axis(a_plot.plot_stack.plots{1});
    else
      a_plot = plotVar(p_stats(param_num), 1, test_num + 1, '', ...
		       struct('rotateYLabel', rotate_labels));
      % Calculate the maximal axis range
      axis_ranges = axis(a_plot);
    end

    if isempty(ranges)
      ranges = axis_ranges;
    else
      ranges = growRange([ranges; axis_ranges]);
    end
    
    % add relative size for stacking from page dimension
    relativeSizes(param_num) = dbsize(p_stats(param_num), 3);

    plots{param_num} = a_plot; %setProp(a_plot, 'tightLimits', 1);
  end
  if test_num == num_tests
    horiz_props = struct('titlesPos', 'none', 'yLabelsPos', 'left', ...
			 'yTicksPos', 'left', 'relativeSizes', relativeSizes);
  else
    horiz_props = struct('titlesPos', 'none', 'yLabelsPos', 'left', ...
			 'yTicksPos', 'left', 'xLabelsPos', 'none', ...
			 'xTicksPos', 'none', 'relativeSizes', relativeSizes);
  end

  % fixed y-axis bounds, but flexible x-axis
  plot_rows{test_num} = plot_stack(plots, [NaN NaN ranges(3:4)], 'x', '', horiz_props);
end

title_str = [ get(p_stats(1), 'id') ];
% 'Measure Variations with Parameter Values'

a_plot_stack = plot_stack(plot_rows, [], 'y', ...
			  title_str, ...
			  mergeStructs(props, struct('titlesPos', 'none', ...
						     'xLabelsPos', 'bottom', ...
						     'xTicksPos', 'bottom')));
