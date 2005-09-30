function a_plot = plot_bars(a_stats_db, title_str, props)

% plot_bars - Creates an bar graph with errorbars for each db column. Looks for 'min', 'max', and 'std' labels in the row_idx for drawing the errorbars.
%
% Usage:
% a_plot = plot_bars(a_stats_db, title_str, props)
%
% Description:
%   Generates a plot_simple object from this histogram.
%
%   Parameters:
%	a_stats_db: A histogram_db object.
%	command: Plot command (Optional, default='bar')
%		
%   Returns:
%	a_plot: A object of plot_bars or one of its subclasses.
%
% See also: plot_abstract, plot_simple
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/08

if ~ exist('props')
  props = struct([]);
end

if ~ exist('title_str')
  title_str = '';
end

%# Setup lookup tables
col_names = fieldnames(get(a_stats_db, 'col_idx'));
data = get(a_stats_db, 'data');
row_idx = get(a_stats_db, 'row_idx');
num_cols = dbsize(a_stats_db, 2);
num_pages = dbsize(a_stats_db, 3);

if isfield(row_idx, 'min')
  lows = data(row_idx.min,:, :) - data(1,:, :);
elseif isfield(row_idx, 'std')
  lows = zeros(1, num_cols, num_pages);  
  highs = data(row_idx.std,:,:);
elseif isfield(row_idx, 'se')
  lows = zeros(1, num_cols, num_pages);  
  highs = data(row_idx.se,:,:);
end

if isfield(row_idx, 'max')
  highs = data(row_idx.max,:,:) - data(1,:,:);
end

if isfield(row_idx, 'n')
  ns = data(row_idx.n,:,:);
else 
  ns = [];
end

stats_props = get(a_stats_db, 'props');
if isfield(stats_props, 'axis_limits')
  axis_limits = stats_props.axis_limits;
else
  axis_limits = [];
end

swaprowspages = [3 2 1];
mids = permute(data(1,:,:), swaprowspages);
lows = permute(lows, swaprowspages);
highs = permute(highs, swaprowspages);
ns = permute(ns, swaprowspages);

if ~isfield(props, 'quiet') && ~isfield(a_stats_db.props, 'quiet')
  title_str = [ get(a_stats_db, 'id') title_str ];
end

a_plot = plot_bars(mids, lows, highs, ns, ...
		   col_names, title_str, axis_limits, ...
		   mergeStructs(props, stats_props));
