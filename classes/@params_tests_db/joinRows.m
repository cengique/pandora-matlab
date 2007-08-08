function a_db = joinRows(db, tests, with_db, w_tests, index_col_name)

% joinRows - Joins the rows of the given db with rows of with_db with matching
%  	RowIndex values.
%
% Usage:
% a_db = joinRows(db, tests, with_db, w_tests, index_col_name)
%
% Description:
%   Takes the desired columns in with_db with rows having a 
% row index and joins them next to dedired columns from the current db. 
% Assumes each row index only appears once in with_db. The created
% db preserves the ordering of with_db.
%
%   Parameters:
%	db: A param_tests_db object.
%	tests: Test columns to take from db.
%	with_db: A tests_db object with a RowIndex column.
%	w_tests: Test columns to take from with_db.
%	index_col_name: (Optional) Name of row index column (default='RowIndex').
%		
%   Returns:
%	a_db: A params_tests_db object.
%
% See also: tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/16

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

%# calculate correct number of parameters left after the join
%# Re-adjust the number of params if some are gone
cols = sort(tests2cols(db, tests));
num_params = sum(cols <= db.num_params);

if ~ exist('index_col_name')
  index_col_name = 'RowIndex';
end

%# Call super class method
a_db = params_tests_db(num_params, ...
		       joinRows(db.tests_db, tests, with_db, w_tests, index_col_name), ...
		       get(db, 'props'));
