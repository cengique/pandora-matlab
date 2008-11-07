function a_plot = plot_bars_ax(a_stats_db, title_str, props)

% plot_bars_ax - Bar plot with extending errorbars for all columns in the same axis.
%
% Usage:
% a_plot = plot_bars_ax(a_tests_db, row, props)
%
% Parameters:
%	a_stats_db: A stats_db object.
%	title_str: Optional title string.
%	props: A structure with any optional properties.
%	  putLabels: Put special column name labels.
%		
% Returns:
%	a_plot: A plot_abstract object that can be plotted.
%
% Description:
%   Differs from stats_db/plot_bars because it does not open a new axis
% for each column. This is only suitable if all columns have similar extents.
%
% See also: plot_abstract, plotFigure, stats_db/plot_bars
%
% $Id: plot_bars_ax.m 966 2008-02-11 21:06:54Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2008/04/17

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

if ~ exist('title_str', 'var')
  title_str = '';
end

% Setup lookup tables
col_names = strrep(fieldnames(get(a_stats_db, 'col_idx')), '_', ' ');
data = get(a_stats_db, 'data');
row_idx = get(a_stats_db, 'row_idx');
num_cols = dbsize(a_stats_db, 2);
num_pages = dbsize(a_stats_db, 3);

mids = data(1,:,:);

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

if ~isfield(props, 'quiet')
  title_str = [ get(a_stats_db, 'id') title_str ];
end

plot_props.groupValues = ...
    getColNames(a_stats_db);

swaprowspages = [2 1 3];
mids = permute(mids, swaprowspages);
lows = permute(lows, swaprowspages);
highs = permute(highs, swaprowspages);
ns = permute(ns, swaprowspages);

% use plot_bars in grouped mode
a_plot = plot_bars(mids, lows, highs, ns, ...
		   { ' ' }, { '' }, ... % leave blank x label to get the margin
                   title_str, [], ...
		   mergeStructs(props, ...
                                plot_props));


