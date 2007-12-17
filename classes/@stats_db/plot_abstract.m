function a_plot = plot_abstract(a_stats_db, title_str, props)

% plot_abstract - Generates an error bar graph for each db columns. 
%
% Usage:
% a_plot = plot_abstract(a_stats_db, title_str, props)
%
% Description:

%   Generates a plot_simple object from this histogram. Looks for 'mean',
% 'min', 'max', and 'STD' labels in the row_idx for drawing the
% errorbars. Each column of a_stats_db is shown in a separate
% axis. Values from multiple pages of a_stats_db are shown as distinct
% points in the axis.
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

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('title_str')
  title_str = '';
end

if ~ exist('props')
  props = struct([]);
end

% Setup lookup tables
col_names = properTeXLabel(fieldnames(get(a_stats_db, 'col_idx')));
data = get(a_stats_db, 'data');
row_idx = get(a_stats_db, 'row_idx');

if isfield(row_idx, 'mean')
  mids = data(row_idx.mean, :, :);
elseif isfield(row_idx, 'median')
  mids = data(row_idx.median, :, :);
else
  disp('Row names:')
  disp(fieldnames(row_idx));
  error('Cannot find the middle values from the above row names in stats_db.');
end

if isfield(row_idx, 'min')
  lows = data(row_idx.min, :, :) - mids;
elseif isfield(row_idx, 'STD')
  lows = -data(row_idx.STD,:, :);  
  highs = data(row_idx.STD,:, :);
elseif isfield(row_idx, 'SE')
  lows = -data(row_idx.SE,:, :);  
  highs = data(row_idx.SE,:, :);
end

if isfield(row_idx, 'max')
  highs = data(row_idx.max,:, :) - mids;
end

stats_props = get(a_stats_db, 'props');
if isfield(stats_props, 'axis_limits')
  axis_limits = stats_props.axis_limits;
else
  axis_limits = [];
end

swaprowspages = [3 2 1];
mids = permute(mids, swaprowspages)
lows = permute(lows, swaprowspages)
highs = permute(highs, swaprowspages)


a_plot = plot_errorbars(mids, lows, highs, ...
			col_names, [ get(a_stats_db, 'id') title_str], ...
			axis_limits, ...
			mergeStructs(props, stats_props));
