function a_plot = plot_bars(a_tests_db, title_str, props)

% plot_bars - Creates a bar graph comparing all DB rows in groups, with a separate axis for each column.
%
% Usage:
% a_plot = plot_bars(a_tests_db, title_str, props)
%
% Description:
%
%   Parameters:
%	a_tests_db: A tests_db object.
%	title_str: (Optional) The plot title.
%	props: A structure with any optional properties.
%		
%   Returns:
%	a_plot: A object of plot_bars or one of its subclasses.
%
% See also: plot_abstract, plot_simple
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/03/13

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props')
  props = struct;
end

if ~ exist('title_str')
  title_str = '';
end

% Setup lookup tables
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

props.dispErrorbars = 0;
props.dispNvals = 0;

a_plot = plot_bars(data, zeros(size(data)), zeros(size(data)), ones(size(data)), ...
		   cell(1, length(col_names)), col_names, title_str, axis_limits, ...
		   mergeStructs(props, stats_props));
