function a_pm = plotTestsHistsMatrix(a_db, title_str, props)

% plotTestsHistsMatrix - Create a matrix plot of test histograms.
%
% Usage:
% a_pm = plotTestsHistsMatrix(a_db, title_str, props)
%
% Parameters:
%   a_db: One or more params_tests_db object. Multiple databases in an
%	  array will produce vertical stacks.
%   title_str: (Optional) A string to be concatanated to the title.
%   props: A structure with any optional properties, passed to plot_abstract.
%     orient: Orientation of the plot_stack. 'x', 'y', or 'matrix' (default).
%     histBins: Number of histogram bins.
%     quiet: Don't put the DB id on the title.
%     plotProps: Props passed to individual plots.
%     stackProps: Passed to vertical plot stacks.
% 
% Returns:
%   a_pm: A plot_stack with the plots organized in matrix form.
%
% Description:
%   Skips the 'ItemIndex' test. If no axisLimits is given in stackProps, 
% y-ranges are the maximal found from db.
%
% See also: params_tests_profile, plotVar
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/17

% Copyright (c) 2007-2011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% TODO:

if ~ exist('title_str', 'var')
  title_str = '';
end

if ~ exist('props', 'var')
  props = struct;
end

stack_props = getFieldDefault(props, 'stackProps', struct);

if isfield(props, 'histBins')
  hist_pars = {a_db, props.histBins};
else
  hist_pars = {a_db};
end

num_tests = dbsize(a_db(1), 2);

if ~ isfield(props, 'quiet')
  all_title = ['Measure histograms for ' get(a_db(1), 'id') title_str ];
else
  all_title = title_str;
end

num_dbs = length(a_db);
if num_dbs > 1
  hists_cell = testsHists(hist_pars{:});
  [all_pm(1:num_tests)] = deal(plot_stack);
  for test_num=1:num_tests
    plots = plot_abstract(hists_cell(test_num, :), '', ...
			  mergeStructs(getFieldDefault(props, 'plotProps', ...
                                                              struct), ...
                                       struct('rotateXLabel', 10)));
    % find maximal y-axis value
    hists = hists_cell(test_num, :);
    max_val = -Inf;
    for db_num=1:num_dbs
      max_val = max(max_val, ...
		    max(get(onlyRowsTests(hists(db_num), ':', 'histVal'), ...
			    'data'), [], 1));
    end

      extra_props = ...
          mergeStructs(stack_props, struct('xLabelsPos', 'bottom', 'xTicksPos', 'bottom'));

      % no need for this, controlled by final stack props
% $$$     if test_num == 1
% $$$     else
% $$$       extra_props = ...
% $$$           mergeStructs(stack_props, struct('xLabelsPos', 'bottom', 'xTicksPos', 'bottom', ...
% $$$                                            'yLabelsPos', 'none'));
% $$$       % Change to 'none' if 'yTicksPos'='left' is given in stackProps
% $$$       if strcmp(getFieldDefault(stack_props, 'yTicksPos', ''), 'left')
% $$$         extra_props = ...
% $$$             mergeStructs(struct('yTicksPos', 'none'), extra_props);
% $$$       end
% $$$     end

    if isfield(stack_props, 'axisLimits')
      axis_limits = stack_props.axisLimits;
    else
      axis_limits = repmat(Inf, 1, 4);
      axis_limits(3:4) = [0 max_val];
    end

    % vertical histogram stack for each test
    all_pm(test_num) = plot_stack(plots, axis_limits, 'y', '', ...
				  extra_props);
  end
  % final horizontal stack
  a_pm = plot_stack(num2cell(all_pm), [], 'x', ...
                    all_title, mergeStructs(props, ...
                                            struct('xLabelsPos', 'bottom', 'xTicksPos', 'bottom', ...
                                                   'yLabelsPos', 'left')));
else % num_dbs > 1
  plots = plot_abstract(testsHists(hist_pars{:}), '', ...
                        mergeStructs(props, struct('rotateXLabel', 10)));
  
  if isfield(props, 'orient') && strcmp(props.orient, 'x')  
    extra_props = struct('yLabelsPos', 'left');
  else
    extra_props = struct;
  end

  if isfield(props, 'orient') && (strcmp(props.orient, 'x')  || ...
                                  strcmp(props.orient, 'y'))
    a_pm = plot_stack(plots, ...
                      getFieldDefault(stack_props, 'axisLimits', []), props.orient, ...
                      all_title, ...
                      mergeStructs(props, ...
                                   mergeStructs(stack_props, extra_props)));
  else
    a_pm = matrixPlots(plots, {}, all_title, props);
  end

end