function a_db = joinRows(db, tests, with_db, w_tests)

% joinRows - Joins the rows of the given db with rows of with_db with matching
%  	RowIndex values.
%
% Usage:
% a_db = joinRows(db, tests, with_db, w_tests)
%
% Description:
%   Takes the desired columns in with_db with rows having a 
% row index and joins them next to dedired columns from the current db. 
% Assumes each row index only appears once in with_db. The created
% db preserves the ordering of with_db.
%
%   Parameters:
%	db: A param_tests_db object.
%	with_db: A tests_db object with a RowIndex column.
%		
%   Returns:
%	a_db: A tests_db object.
%
% See also: tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/16

%# TODO: calculate correct number of parameters left after the join

%# Call super class method
a_db = params_tests_db(db.num_params, ...
		       joinRows(db.tests_db, tests, with_db, w_tests), ...
		       db.props);
