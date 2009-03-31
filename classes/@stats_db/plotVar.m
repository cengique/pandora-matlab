function a_plot = plotVar(a_stats_db, test1, test2, title_str, props)

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
%	title_str: (Optional) String to append to plot title.
%	props: Optional properties.
%	  plotType: 1, only errorbars (default); 2, errorbars extending from bars.
%	  quiet: If 1, only display given title_str.
%	  (rest passed to plot_abstract)
%		
%   Returns:
%	a_plot: A plot_abstract object or one of its subclasses.
%
% See also: plotVar, plot_simple
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/13

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct([]);
end

if ~ exist('title_str', 'var')
  title_str = '';
end

% Setup lookup tables
col_names = properTeXLabel(fieldnames(get(a_stats_db, 'col_idx')));
data = get(a_stats_db, 'data');
row_idx = get(a_stats_db, 'row_idx');

col1 = tests2cols(a_stats_db, test1);
col2 = tests2cols(a_stats_db, test2);

if isfield(row_idx, 'min')
  lows = data(row_idx.min, :, :) - data(1, :, :);
elseif isfield(row_idx, 'STD')
  lows = -data(row_idx.STD, :, :);  
  highs = data(row_idx.STD, :, :);
elseif isfield(row_idx, 'SE')
  lows = -data(row_idx.SE, :, :);  
  highs = data(row_idx.SE, :, :);
end

if isfield(row_idx, 'max')
  highs = data(row_idx.max, :, :) - data(1, :, :);
end

a_stats_db_props = get(a_stats_db, 'props');
if isfield(a_stats_db_props, 'axis_limits')
  axis_limits = a_stats_db_props.axis_limits;
else
  axis_limits = [];
end

col1name = col_names{col1};
col2name = col_names{col2};

props = mergeStructs(props, a_stats_db_props);

the_title = [ 'Variations from ' get(a_stats_db, 'id')];
if isfield(props, 'quiet')
  if ~ isempty(title_str)
    the_title = title_str;
  end
else
  if ~ isempty(title_str)
    the_title = [ the_title title_str ];
  end
end

if isfield(props, 'plotType') && props.plotType == 2
  % Not implemented, left half-finished?? plot_bars provide the required functionality?
  a_plot = plot_errorbar(data(1, col1, :), data(1, col2, :), ...
			 lows(1, col2, :), highs(1, col2, :), '', ...
			 {col1name, col2name}, ...
			 the_title, {}, ...
			 props);
else
  a_plot = plot_errorbar(data(1, col1, :), data(1, col2, :), ...
			 lows(1, col2, :), highs(1, col2, :), '', ...
			 {col1name, col2name}, ...
			 the_title, {}, ...
			 props);
end
