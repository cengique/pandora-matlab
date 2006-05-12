function a_plot = plot_bars(a_tests_db, title_str, props)

% plot_bars - Creates a bar graph comparing all DB rows, with a separate axis for each column.
%
% Usage:
% a_plot = plot_bars(a_tests_db, title_str, props)
%
% Description:
%
%   Parameters:
%	a_tests_db: A tests_db object.
%	command: Plot command (Optional, default='bar')
%		
%   Returns:
%	a_plot: A object of plot_bars or one of its subclasses.
%
% See also: plot_abstract, plot_simple
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/03/13

if ~ exist('props')
  props = struct([]);
end

if ~ exist('title_str')
  title_str = '';
end

%# Setup lookup tables
col_names = properTeXLabel(fieldnames(get(a_tests_db, 'col_idx')));
data = get(a_tests_db, 'data');
row_idx = get(a_tests_db, 'row_idx');
num_rows = dbsize(a_tests_db, 1);
num_cols = dbsize(a_tests_db, 2);

stats_props = get(a_tests_db, 'props');
if isfield(stats_props, 'axis_limits')
  axis_limits = stats_props.axis_limits;
else
  axis_limits = [];
end

if ~isfield(props, 'quiet') && ~isfield(get(a_tests_db, 'props'), 'quiet')
  title_str = [ get(a_tests_db, 'id') title_str ];
end

a_plot = plot_bars(data, zeros(size(data)), zeros(size(data)), ones(size(data)), ...
		   col_names, title_str, axis_limits, ...
		   mergeStructs(props, stats_props));
