function a_pm = plotParamsCoverage(a_db, params, title_str, props)

% plotParamsCoverage - Lower triangle matrix of parameter-parameter combination scatter plots.
%
% Usage:
% a_pm = plotParamsCoverage(a_db, params, title_str, props)
%
% Parameters:
%   a_db: A tests_db or params_tests_db object. 
%   params: Columns to be used in the parameter coverage.
%   title_str: (Optional) A string to be concatanated to the title.
%   props: A structure with any optional properties, passed to plot_abstract.
%     colorTest: Use this column to specify colors of points (see
%     		plotScatter for other props to control behavior).
%     quiet: Don't put the DB id on the title.
%     (rest passed to plotScatter)
% 
% Returns:
%   a_pm: Resulting plot_stack object.
%
% Description:
%
% See also: plotScatter
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2016/05/27

% Copyright (c) 2016 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('title_str', 'var')
  title_str = '';
end

if ~ exist('props', 'var')
  props = struct;
end

color_test = getFieldDefault(props, 'colorTest', []);

if isempty(color_test)
  color_test = {};
else
  color_test = { color_test };
end

param_db = onlyRowsTests(a_db, ':', { params, color_test{:} });

num_params = dbsize(param_db, 2);

if ~ isempty(color_test)
  num_params = num_params - 1;
end

if ~ isfield(props, 'quiet')
  all_title = ['Parameter coverage for ' get(a_db(1), 'id') title_str ];
else
  all_title = title_str;
end

% create a square matrix even though we're filling only the bottom triangle
plot_matx = cell(num_params - 1);
y_stack = cell(num_params - 1, 1);

% rows
for row_num = 1:(num_params-1)
  [plot_matx{row_num, 1:(num_params - 1)}] = deal(plot_abstract);

  % show colorbar only on the top left plot
  show_colorbar = 0;
  if ~ isempty(color_test) && row_num == 1
    show_colorbar = 1;
  end
  
  % columns 
  for col_num = 1:row_num
    plot_matx{row_num, col_num} = ...
        plotScatter(param_db, col_num, row_num + 1, ...
                    all_title, '', ...
                    mergeStructs(props, struct('colorbar', show_colorbar)));
  end

  y_stack_props = ...
      struct('yTicksPos', 'left', 'yLabelsPos', 'left');

  % show X ticks & labels only on last row
  if row_num < (num_params - 1)
    y_stack_props = ...
        mergeStructs(y_stack_props, ...
                     struct('xTicksPos', 'none', 'xLabelsPos', 'none'));
  end
  
  y_stack{row_num} = ...
      plot_stack({plot_matx{row_num, :}}, [], 'x', '', ...
                 mergeStructs(props, ...
                              y_stack_props));
end

% make last row taller to give space for ticks & labels
a_pm = ...
    plot_stack(y_stack, [], 'y', '', ...
               mergeStructs(props, struct('relativeSizes', [ repmat(1, 1, num_params - 2) 1.5 ])));
  