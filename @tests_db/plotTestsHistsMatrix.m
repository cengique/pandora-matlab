function a_pm = plotTestsHistsMatrix(a_db, title_str, props)

% plotTestsHistsMatrix - Create a matrix plot of test histograms.
%
% Usage:
% a_pm = plotTestsHistsMatrix(a_db, title_str, props)
%
% Description:
%   Skips the 'ItemIndex' test.
%
%   Parameters:
%	a_db: A params_tests_db object.
%	title_str: (Optional) A string to be concatanated to the title.
%	props: A structure with any optional properties, passed to plot_abstract.
%	  orient: Orientation of the plot_stack. 'x', 'y', or 'matrix' (default).
%	  histBins: Number of histogram bins.
%	  quiet: Don't put the DB id on the title.
%	  axisLimits: Only x-ranges are used from this expression.
% 
%   Returns:
%	a_pm: A plot_stack with the plots organized in matrix form
%
% See also: params_tests_profile, plotVar
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/17

if ~ exist('title_str')
  title_str = '';
end

if ~ exist('props')
  props = struct;
end

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
    plots = plot_abstract(hists_cell{test_num}, '', ...
			  mergeStructs(props, struct('rotateXLabel', 10)));
    %# find maximal y-axis value
    hists = hists_cell{test_num};
    max_val = -Inf;
    for db_num=1:num_dbs
      max_val = max(max_val, ...
		    max(get(onlyRowsTests(hists(db_num), ':', 'histVal'), ...
			    'data'), [], 1));
    end

    if test_num == 1
      extra_props = struct('xLabelsPos', 'bottom', 'yLabelsPos', 'left');
    else
      extra_props = struct('xLabelsPos', 'bottom', 'yLabelsPos', 'none');
    end

    if isfield(props, 'axisLimits')
      axis_limits = props.axisLimits;
    else
      axis_limits = repmat(NaN, 1, 4);
    end
    axis_limits(3:4) = [0 max_val];

    %# vertical histogram stack for each test
    all_pm(test_num) = plot_stack(plots, axis_limits, 'y', '', ...
				  mergeStructs(props, extra_props));
  end
  %# final horizontal stack
  a_pm = plot_stack(all_pm, [], 'x', ...
		   all_title, mergeStructs(props, extra_props));
  
else
plots = plot_abstract(testsHists(hist_pars{:}), '', ...
		      mergeStructs(props, struct('rotateXLabel', 10)));

if isfield(props, 'orient') && strcmp(props.orient, 'x')  
  extra_props = struct('yLabelsPos', 'left');
else
  extra_props = struct;
end

if isfield(props, 'orient') && (strcmp(props.orient, 'x')  || ...
				strcmp(props.orient, 'y'))
  a_pm = plot_stack(plots, [], props.orient, ...
		   all_title, mergeStructs(props, extra_props));
else
  a_pm = matrixPlots(plots, {}, all_title, props);
end

end