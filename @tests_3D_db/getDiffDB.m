function a_tests_db = getDiffDB(a_db, test, props)

% getDiffDB - Creates a tests_db by taking the derivative of the given test.
%
% Usage:
% a_tests_db = getDiffDB(a_db, test, props)
%
% Description:
%   Applies the diff function to the chosen test, and collapses the middle
% dimension of the 3D DB to create a 2D DB.
%
%   Parameters:
%	a_db: A tests_3D_db object.
%	test: Test column.
%	props: Optional properties.
%		
%   Returns:
%	a_tests_db: A tests_db that holds the requested differences of parameter values.
%
% See also: boxplot, plot_abstract
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/11/10

if ~ exist('props')
  props = struct([]);
end

if dbsize(a_db, 1) <= 1
  error('More than one row is required to take diffs!');
end

test_names = fieldnames(get(a_db, 'col_idx'));

col_names = {};
for col=1:(dbsize(a_db, 1) - 1)
  col_names{col} = [ 'd' num2str(col) '_' num2str(col + 1) ];
end

a_db_props = get(a_db, 'props');

db_id = [ 'Change of ' test_names{tests2cols(a_db, test)} ...
	 ' between levels of ' a_db_props.invarName ];

a_tests_db = tests_db(transpose(squeeze(diff(get(onlyRowsTests(a_db, ':', test), 'data')))), ...
		      col_names, {}, db_id);
