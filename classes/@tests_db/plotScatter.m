function a_p = plotScatter(a_db, test1, test2, title_str, short_title, props)

% plotScatter - Create a scatter plot of the given two tests.
%
% Usage:
% a_p = plotScatter(a_db, test1, test2, title_str, short_title, props)
%
% Description:
%
%   Parameters:
%	a_db: A params_tests_db object.
%	test1, test2: X & Y variables.
%	title_str: (Optional) A string to be concatanated to the title.
%	short_title: (Optional) Few words that may appear in legends of multiplot.
%	props: A structure with any optional properties.
%	  LineStyle: Plot line style to use. (default: 'x')
%	  Regress: Calculate and plot a linear regression.
%	  quiet: If 1, don't include database name on title.
%		
%   Returns:
%	a_p: A plot_abstract.
%
% See also: 
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/09/29

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('title_str')
  title_str = '';
end

if ~ exist('props')
  props = struct;
end

col1 = tests2cols(a_db, test1);
col2 = tests2cols(a_db, test2);

col1_db = onlyRowsTests(a_db, ':', col1);
col2_db = onlyRowsTests(a_db, ':', col2);

% skip NaN value rows
non_nans_rows = ~(isnan(col1_db) | isnan(col2_db));
col1_db = onlyRowsTests(col1_db, non_nans_rows, ':');
col2_db = onlyRowsTests(col2_db, non_nans_rows, ':');

test_names = fieldnames(get(a_db, 'col_idx'));

if ~ exist('short_title') || isempty(short_title)
  short_title = [ strrep(test_names{col1}, '_', ' ') ' vs. ' ...
		 strrep(test_names{col2}, '_', ' ') ];
end

if ~ isfield(props, 'quiet')
  all_title = [ strrep(get(a_db, 'id'), '_', '\_') title_str ];
else
  all_title = title_str;
end


if isfield(props, 'LineStyle')
  line_style = {props.LineStyle};
else
  line_style = {};
  props.LineStyleOrder = {'x', '+', 'd', 'o', '*', 's'};
end

if isfield(props, 'Regress')
  [b,bint,r,rint,stats] = ...
      regress(get(col2_db, 'data'), [ones(dbsize(col1_db, 1), 1), ...
				     get(col1_db, 'data')]);
  if ~isempty(all_title)
    all_title = [ all_title, '; '];
  end
  all_title = [ all_title, 'regress p=' sprintf('%.4f', stats(3)) ];
end

col_labels = strrep({test_names{[col1 col2]}}, '_', ' ');
a_p = plot_abstract({get(col1_db, 'data'), get(col2_db, 'data'), line_style{:}}, ...
		    { col_labels{:} }, ...
		    all_title, { short_title }, 'plot', ...
		    props); 

if isfield(props, 'Regress')
  x_lims = [min(get(col1_db, 'data')) max(get(col1_db, 'data'))];
  a_p = plot_superpose([a_p, plot_abstract({x_lims, x_lims * b(2) + b(1), 'm-'}, ...
					   { }, '', { '' }, 'plot', props)], {}, '');
end