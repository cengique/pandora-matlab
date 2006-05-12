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
%		
%   Returns:
%	a_plot_stack: A plot_stack with the plots organized in matrix form
%
% See also: paramsTestsHistsStats, params_tests_profile, plotVar.
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/17

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
    a_plot = plotVar(p_stats{param_num}, 1, test_num + 1, ...
		     struct('rotateYLabel', 60));
    %# Calculate the maximal axis range
    if isempty(ranges)
      ranges = axis(a_plot);
    else
      ranges = growRange([ranges; axis(a_plot)]);
    end
    plots{param_num} = a_plot;
  end
  if test_num == 1
    props = struct('titlesPos', 'none', ...
		   'yLabelsPos', 'left', ...
		   'yTicksPos', 'left');
  else
    props = struct('titlesPos', 'none', ...
		   'yLabelsPos', 'left', ...
		   'yTicksPos', 'left', ...
		   'xLabelsPos', 'none', ...
		   'xTicksPos', 'none');
  end

  %# fixed y-axis bounds, but flexible x-axis
  plot_rows{test_num} = plot_stack(plots, [NaN NaN ranges(3:4)], 'x', '', props);
end

title_str = [ p_stats{1}.id ];
%# 'Measure Variations with Parameter Values'

a_plot_stack = plot_stack(plot_rows, [], 'y', ...
			  title_str, ...
			  mergeStructs(props, struct('titlesPos', 'none', ...
						     'xLabelsPos', 'bottom', ...
						     'xTicksPos', 'bottom')));
