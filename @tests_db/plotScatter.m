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
%		LineStyle: Plot line style to use. (default: 'x')
%		
%   Returns:
%	a_p: A plot_abstract.
%
% See also: 
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/09/29

if ~ exist('title_str')
  title_str = '';
end

if ~ exist('props')
  props = struct([]);
end

col1 = tests2cols(a_db, test1);
col2 = tests2cols(a_db, test2);

col1_db = onlyRowsTests(a_db, ':', col1);
col2_db = onlyRowsTests(a_db, ':', col2);

test_names = fieldnames(get(a_db, 'col_idx'));

all_title = [ strrep(get(a_db, 'id'), '_', '\_') title_str ];

if ~ exist('short_title')
  short_title = [ test_names{col1} ' vs. ' test_names{col2} ];
end

if isfield(props, 'LineStyle')
  line_style = {props.LineStyle};
else
  line_style = {};
  props.LineStyleOrder = {'x', '+', 'd', 'o', '*', 's'};
end

col_labels = strrep({test_names{[col1 col2]}}, '_', ' ');
a_p = plot_abstract({get(col1_db, 'data'), get(col2_db, 'data'), line_style{:}}, ...
		    { col_labels{:} }, ...
		    all_title, { short_title }, 'plot', ...
		    props); 

