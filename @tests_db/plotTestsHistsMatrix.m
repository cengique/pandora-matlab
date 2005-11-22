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
% 
%   Returns:
%	a_pm: A plot_stack with the plots organized in matrix form
%
% See also: params_tests_profile, plotVar
%
% $Id$
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

plots = plot_abstract(testsHists(hist_pars{:}), '', ...
		      mergeStructs(props, struct('rotateXLabel', 10)));

if isfield(props, 'orient') && strcmp(props.orient, 'x')  
  extra_props = struct('yLabelsPos', 'left');
else
  extra_props = struct;
end

if ~ isfield(props, 'quiet')
  all_title = ['Measure histograms for ' get(a_db, 'id') title_str ];
else
  all_title = title_str;
end

if isfield(props, 'orient') && (strcmp(props.orient, 'x')  || ...
				strcmp(props.orient, 'y'))
  a_pm = plot_stack(plots, [], props.orient, ...
		   all_title, mergeStructs(props, extra_props));
else
  a_pm = matrixPlots(plots, {}, all_title, props);
end

