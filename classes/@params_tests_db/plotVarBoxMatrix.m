function a_plot_stack = plotVarBoxMatrix(a_db, p_t3ds, props)

% plotVarBoxMatrix - Create a stack of parameter-test variation plots 
%		organized in a matrix.
%
% Usage:
% a_plot_stack = plotVarBoxMatrix(a_db, p_t3ds)
%
% Description:
%   Skips the 'ItemIndex' test.
%
%   Parameters:
%	a_db: A tests_db object.
%	p_t3ds: Cell array of invariant parameter databases.
%		
%   Returns:
%	a_plot_stack: A plot_stack with the plots organized in matrix form
%
% See also: params_tests_profile, plotVar
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/17

if ~ exist('props')
  props = struct([]);
end

num_params = a_db.num_params;
num_tests = dbsize(a_db, 2) - num_params - 1; %# Except the item indices

for param_num=1:num_params
  pss_t3ds{param_num} = swapRowsPages(sortrows(p_t3ds{param_num}, 1));
end

%# TODO: Row stacks with 
plot_rows = cell(1, num_tests);
for test_num=1:num_tests

  plots = cell(1, num_params);  
  ranges = [];
  for param_num=1:num_params
    a_plot = plotVarBox(pss_t3ds{param_num}, 1, test_num + 1, ...
			1, 'r.', 1, 1.5, ...
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
    rprops = struct('titlesPos', 'none', ...
		    'yLabelsPos', 'left', ...
		    'yTicksPos', 'left');
  else
    rprops = struct('titlesPos', 'none', ...
		    'yLabelsPos', 'left', ...
		    'yTicksPos', 'left', ...
		    'xLabelsPos', 'none', ...
		    'xTicksPos', 'none');
  end

  %# fixed y-axis bounds, but flexible x-axis (reversed for boxplot weirdness)
  plot_rows{test_num} = plot_stack(plots, [NaN NaN ranges(1:2)], 'x', '', rprops);
end

%# User passed properties take precedence
vprops = mergeStructs(props, struct('titlesPos', 'none', ...
				    'xLabelsPos', 'bottom', ...
				    'xTicksPos', 'bottom'));

a_plot_stack = plot_stack(plot_rows, [], 'y', ...
			  ['Measure Variations with Parameter Values in ' ...
			   get(a_db, 'id')], ...
			  vprops);
