function a_plot = plotVar(a_stats_db, test1, test2, props)

% plotVar - Generates a plot of the variation between two tests.
%
% Usage:
% a_plot = plotVar(a_stats_db, test1, test2, props)
%
% Description:
%   Creates a plot description where the mean values are used for solid lines
% and the std values of test2 is indicated with errorbars. It is assumed that 
% each page of the stats_db contains a value to be matched.
%
%   Parameters:
%	a_stats_db: A stats_db object.
%	test1: Test column for the x-axis, only mean values are used.
%	test2: Test column for the y-axis, std values are indicated with errorbars.
%	props: Optional properties to be passed to plot_abstract.
%		
%   Returns:
%	a_plot: A plot_abstract object or one of its subclasses.
%
% See also: plotVar, plot_simple
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/13

if ~ exist('props')
  props = struct([]);
end

%# Setup lookup tables
col_names = fieldnames(get(a_stats_db, 'col_idx'));
data = get(a_stats_db, 'data');
row_idx = get(a_stats_db, 'row_idx');

col1 = tests2cols(a_stats_db, test1);
col2 = tests2cols(a_stats_db, test2);

if isfield(row_idx, 'min')
  lows = data(row_idx.min, :, :) - data(1, :, :);
elseif isfield(row_idx, 'std')
  lows = -data(row_idx.std, :, :);  
  highs = data(row_idx.std, :, :);
elseif isfield(row_idx, 'se')
  lows = -data(row_idx.se, :, :);  
  highs = data(row_idx.se, :, :);
end

if isfield(row_idx, 'max')
  highs = data(row_idx.max, :, :) - data(1, :, :);
end

if isfield(a_stats_db.props, 'axis_limits')
  axis_limits = a_stats_db.props.axis_limits;
else
  axis_limits = [];
end

col1name = col_names{col1};
col2name = col_names{col2};

props = mergeStructs(props, a_stats_db.props);

a_plot = plot_errorbar(data(1, col1, :), data(1, col2, :), ...
		       lows(1, col2, :), highs(1, col2, :), '', ...
		       {col1name, col2name}, ...
		       [ 'Variations from ' get(a_stats_db, 'id')], {}, ...
		       props);
