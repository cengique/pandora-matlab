function a_plot = plot_bars(a_stats_db, title_str, props)

% plot_bars - Creates a bar graph with errorbars for each db column. 
%
% Usage:
% a_plot = plot_bars(a_stats_db, title_str, props)
%
% Description:
%   Looks for 'min', 'max', and 'STD' labels in the row_idx for drawing the errorbars. 
% Each page of the DB will produce grouped bars.
%
%   Parameters:
%	a_stats_db: A stats_db object.
%	title_str: The plot title.
%	props: A structure with any optional properties.
%	  pageVariable: The column used for denoting page values.
%	  (passed to plot_bars/plot_bars)
%		
%   Returns:
%	a_plot: A object of plot_bars or one of its subclasses.
%
% See also: plot_abstract, plot_bars/plot_bars
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/08

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props')
  props = struct([]);
end

if ~ exist('title_str')
  title_str = '';
end

if isfield(props, 'pageVariable')
  % Use this column as the per-page information value
  page_vals = squeeze(get(onlyRowsTests(a_stats_db, 1, props.pageVariable, ':'), 'data'));
  % put it in props to pass to plot_bars
  props.groupValues = page_vals;
  page_names = { getColNames(a_stats_db, props.pageVariable) };
  % Then, remove the column
  a_stats_db = delColumns(a_stats_db, props.pageVariable);
else
  page_names = {''};
end

% Setup lookup tables
col_names = strrep(fieldnames(get(a_stats_db, 'col_idx')), '_', ' ');
data = get(a_stats_db, 'data');
row_idx = get(a_stats_db, 'row_idx');
num_cols = dbsize(a_stats_db, 2);
num_pages = dbsize(a_stats_db, 3);

[page_names{1:num_cols}] = deal(page_names{ones(1, num_cols)});

if isfield(row_idx, 'min')
  lows = data(row_idx.min,:, :) - data(1,:, :);
elseif isfield(row_idx, 'STD')
  lows = zeros(1, num_cols, num_pages);  
  highs = data(row_idx.STD,:,:);
elseif isfield(row_idx, 'SE')
  lows = zeros(1, num_cols, num_pages);
  highs = data(row_idx.SE,:,:);
end

% If there are negative elements, put STD and SE on the lows
if (isfield(row_idx, 'STD') || isfield(row_idx, 'SE'))
  neg_data = sign(data(1,:, :)) < 0;
  lows(neg_data) = highs(neg_data);
  highs(neg_data) = 0;
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
elseif isfield(props, 'axis_limits')
  axis_limits = props.axis_limits;
else
  axis_limits = [];
end

swaprowspages = [3 2 1];
mids = permute(data(1,:,:), swaprowspages);
lows = permute(lows, swaprowspages);
highs = permute(highs, swaprowspages);
ns = permute(ns, swaprowspages);

if ~isfield(props, 'quiet') && ~isfield(stats_props, 'quiet')
  title_str = [ get(a_stats_db, 'id') title_str ];
end

a_plot = plot_bars(mids, lows, highs, ns, ...
		   {properTeXLabel(page_names{1})}, col_names, ...
                   title_str, axis_limits, ...
		   mergeStructs(props, stats_props));
