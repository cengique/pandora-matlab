function a_tests_db = diff2D(a_db, test, props)

% diff2D - Creates a tests_db by taking the derivative of the given test.
%
% Usage:
% a_tests_db = diff2D(a_db, test, props)
%
% Description: 
%   Applies the diff function to the chosen test, and collapses the middle
% dimension of the 3D DB to create a 2D DB and transposes it. The result is
% that the pages of the 3D DB becomes the rows of the new database, and the
% differenced rows appear as new columns, each named uniquely. The column
% index would correspons to the row index in the 3D DB. A new column
% 'PageNumber' is appended to point back to the 3D DB.
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
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/05/22

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

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

a_tests_db = ...
    tests_db([ transpose(squeeze(diff(get(onlyRowsTests(a_db, ':', test), 'data')))), (1:dbsize(a_db, 3))'], ...
             { col_names{:}, 'PageIndex' }, {}, db_id);
