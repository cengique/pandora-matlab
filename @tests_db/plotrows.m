function a_plot = plotrows(a_tests_db, axis_limits, orientation, props)

% plotrows - Creates a plot_stack describing the db rows.
%
% Usage:
% a_plot = plotrows(a_tests_db, axis_limits, orientation, props)
%
% Description:
%
%   Parameters:
%	a_tests_db: A tests_db object.
%	axis_limits: If given, all plots contained will have these axis limits.
%	orientation: Stack orientation 'x' for horizontal, 'y' for vertical, etc.
%	props: A structure with any optional properties passed to plot_stack.
%		
%   Returns:
%	a_plot: A plot_stack object that can be plotted.
%
% See also: plot_abstract, plotFigure
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/11/09

if ~ exist('props')
  props = struct([]);
end

if ~ exist('orientation')
  orientation = 'y'
end

num_rows = size(a_tests_db, 1);
plots = cell(num_rows, 1);
for row_num=1:num_rows
  plots{row_num} = plotrow(a_tests_db, row_num);
end

props(1).xLabelsPos = 'bottom';
%#props.xTicksPos = 'bottom';
props.titlesPos = 'none';
a_plot = plot_stack(plots, axis_limits, orientation, get(a_tests_db, 'id'), props);
