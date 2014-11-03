function a_p = plotYTests(a_db, x_vals, tests, axis_labels, title_str, short_title, ...
			  command, props)

% plotYTests - Create a plot given database measures against given X-axis values, for each row.
%
% Usage:
% a_p = plotYTests(a_db, x_vals, tests, axis_labels, title_str, short_title, command, props)
%
% Parameters:
%   a_db: A params_tests_db object.
%   x_vals: A vector of X-axis values.
%   tests: A vector or cell array of columns to correspond to each value from x_vals.
%   axis_labels: Cell array of X & Y axis labels.
%   title_str: (Optional) A string to be concatanated to the title.
%   short_title: (Optional) Few words that may appear in legends of multiplot.
%   command: (Optional) Command to do the plotting with (default: 'plot')
%   props: A structure with any optional properties.
%     LineStyle: Plot line style to use. (default: 'd-')
%     ShowErrorbars: If 1, errorbars are added to each point.
%     StatsDB: If given, use this stats_db for the errorbar (default=statsMeanStd(a_db)).
%     quiet: If 1, don't include database name on title.
%		
% Returns:
%   a_p: A plot_abstract.
%
% Description:
%
% Example:
% >> a_p = plotYTests(a_db_row, [0 40 100 200], ...
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

cols_db = onlyRowsTests(a_db, ':', tests);

test_names = fieldnames(get(a_db, 'col_idx'));

if ~ isfield(props, 'quiet')
  all_title = [ strrep(get(a_db, 'id'), '_', '\_') title_str ];
else
  all_title = title_str;
end

if isfield(props, 'LineStyle')
  line_style = {props.LineStyle};
else
  line_style = {};
  props.LineStyleOrder = {'d-', 'o-', '*-', 's-', 'x-', '+-'};
end

c_data = get(cols_db, 'data')';

if isfield(props, 'ShowErrorbars')
  % read the std from the second page of DB, if exists
  stats_db = getFieldDefault(props, 'StatsDB', statsMeanStd(cols_db));
  stats_db = onlyRowsTests(stats_db, ':', tests);
  a_p = ...
      plot_abstract({x_vals, c_data', get(onlyRowsTests(stats_db, 2, tests), 'data'), ...
                     line_style{:}}, ... % '+'
                    axis_labels, all_title, {short_title}, 'errorbar', props);
  % BUG: command is overridden in this case
else
  % Draw a regular line plot
  a_p = plot_abstract({x_vals, c_data, line_style{:}}, ...
                      axis_labels, all_title, {short_title}, command, props);
end