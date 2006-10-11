function a_plot = plot_abstract(a_stats_db, title_str, props)

% plot_abstract - Generates an error bar graph for each db columns. Looks for 'min', 'max', and 'STD' labels in the row_idx for drawing the errorbars.
%
% Usage:
% a_plot = plot_abstract(a_stats_db, title_str, props)
%
% Description:
%   Generates a plot_simple object from this histogram.
%
%   Parameters:
%	a_stats_db: A histogram_db object.
%	title_str: A title string on the plot
%	props: A structure with any optional properties.
%		
%   Returns:
%	a_plot: A object of plot_abstract or one of its subclasses.
%
% See also: plot_abstract, plot_simple
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/08

if ~ exist('title_str')
  title_str = '';
end

if ~ exist('props')
  props = struct([]);
end

%# Setup lookup tables
col_names = properTeXLabel(fieldnames(get(a_stats_db, 'col_idx')));
data = get(a_stats_db, 'data');
row_idx = get(a_stats_db, 'row_idx');

if isfield(row_idx, 'min')
  lows = data(row_idx.min,:) - data(1,:);
elseif isfield(row_idx, 'STD')
  lows = -data(row_idx.STD,:);  
  highs = data(row_idx.STD,:);
elseif isfield(row_idx, 'SE')
  lows = -data(row_idx.SE,:);  
  highs = data(row_idx.SE,:);
end

if isfield(row_idx, 'max')
  highs = data(row_idx.max,:) - data(1,:);
end

stats_props = get(a_stats_db, 'props');
if isfield(stats_props, 'axis_limits')
  axis_limits = stats_props.axis_limits;
else
  axis_limits = [];
end

a_plot = plot_errorbars(data(1,:), lows, highs, ...
			col_names, [ get(a_stats_db, 'id') title_str], ...
			axis_limits, ...
			mergeStructs(props, stats_props));
