function a_p = plotYTests(a_stats_db, x_vals, tests, axis_labels, title_str, short_title, ...
			  command, props)

% plotYTests - Create an errorbar plot of database stats measures against given X-axis values.
%
% Usage:
% a_p = plotYTests(a_stats_db, x_vals, tests, axis_labels, title_str, short_title, command, props)
%
% Description:
%
% Parameters:
%	a_stats_db: A params_tests_db object.
%	x_vals: A vector of X-axis values.
%	tests: A vector or cell array of columns to correspond to each value from x_vals.
%	title_str: (Optional) A string to be concatanated to the title.
%	short_title: (Optional) Few words that may appear in legends of multiplot.
%	command: (Optional) Command to do the plotting with (default: 'plot')
%	props: A structure with any optional properties.
%		LineStyle: Plot line style to use. (default: 'd-')
%		quiet: If 1, don't include database name on title.
%		
% Returns:
%	a_p: A plot_abstract.
%
% Example:
% >> a_p = plotYTests(a_stats_db, [0 40 100 200], ...
%		      {'IniSpontSpikeRateISI_0pA', 'PulseIni100msSpikeRateISI_D40pA', ...
%		       'PulseIni100msSpikeRateISI_D100pA', 'PulseIni100msSpikeRateISI_D200pA'}, ...
%		      {'current pulse [pA]', 'firing rate [Hz]'}, ', f-I curves', 'neuron 1');
% >> plotFigure(a_p);
%
% See also: plotFigure
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/01/23

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('title_str', 'var')
  title_str = '';
end

if ~ exist('props', 'var')
  props = struct;
end

if ~ exist('short_title', 'var')
  short_title = '';
end

if ~ exist('command', 'var') || isempty(command)
  command = 'plot';
end

cols_db = onlyRowsTests(a_stats_db, ':', tests);

test_names = fieldnames(get(a_stats_db, 'col_idx'));

if ~ isfield(props, 'quiet')
  all_title = [ strrep(get(a_stats_db, 'id'), '_', '\_') title_str ];
else
  all_title = title_str;
end

if isfield(props, 'LineStyle')
  line_style = {props.LineStyle};
else
  line_style = {};
  props.LineStyleOrder = {'d-', 'o-', '*-', 's-', 'x-', '+-'};
end

data = get(cols_db, 'data');
row_idx = get(a_stats_db, 'row_idx');

if isfield(row_idx, 'min')
  lows = c_data - data(row_idx.min, :, :);
elseif isfield(row_idx, 'STD')
  lows = data(row_idx.STD, :, :);  
  highs = data(row_idx.STD, :, :);
elseif isfield(row_idx, 'SE')
  lows = data(row_idx.SE, :, :);  
  highs = data(row_idx.SE, :, :);
end

a_p = plot_errorbar(x_vals, data(1, :, :)', lows', highs', '', axis_labels, ...
		    all_title, {short_title}, mergeStructs(props, get(a_stats_db, 'props')));
