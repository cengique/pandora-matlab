function a_p = plotXRows(a_db, test_y, title_str, short_title, props)

% plotXRows - Create a scatter plot with a test versus the row numbers on the X-axis.
%
% Usage:
% a_p = plotXRows(a_db, test_y, title_str, short_title, props)
%
% Description:
%
%   Parameters:
%	a_db: A params_tests_db object.
%	test_y: Y variable.
%	title_str: (Optional) A string to be concatanated to the title.
%	short_title: (Optional) Few words that may appear in legends of multiplot.
%	props: A structure with any optional properties passed to
%		plotScatter.
%	  RowName: Label to show on X-axis (default='RowNumber')
%		
%   Returns:
%	a_p: A plot_abstract.
%
% See also: 
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2007/01/16

if ~ exist('title_str')
  title_str = '';
end

if ~ exist('short_title')
  short_title = '';
end

if ~ exist('props')
  props = struct;
end

%# Add a new column that keeps count of rows and call plotScatter
if isfield(props, 'RowName')
    new_col_name = props.RowName;
else
    new_col_name = 'RowNumber';
end
col_added_db = addColumns(a_db, {new_col_name}, (1:dbsize(a_db, 1))');

a_p = plotScatter(col_added_db, new_col_name, test_y, title_str, short_title, props);
