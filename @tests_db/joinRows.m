function a_db = joinRows(db, tests, with_db, w_tests)

% joinRows - Joins the rows of the given db with rows of with_db with matching
%  	RowIndex values.
%
% Usage:
% a_db = joinRows(db, tests, with_db, w_tests)
%
% Description:
%   Takes the desired columns in with_db with rows having a 
% row index and joins them next to desired columns from the current db. 
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

data = get(db, 'data');
w_data = get(with_db, 'data');

join_col = tests2cols(with_db, 'RowIndex');
joins = w_data(:, join_col);

size_db = dbsize(db);
size_wdb = dbsize(with_db);

cols = tests2cols(db, tests);
w_cols = tests2cols(with_db, w_tests);

new_size(1) = size_wdb(1);
new_size(2) = length(cols) + length(w_cols); %# Except the page index

new_data = [ data(joins, cols), w_data(:, w_cols) ];

%# Get the column names straight
cols_cell1 = fieldnames(get(db, 'col_idx'));
cols_cell2 = fieldnames(get(with_db, 'col_idx'));
a_db = tests_db(new_data, ...
		{ cols_cell1{cols}, cols_cell2{w_cols} }, ...
		fieldnames(get(db, 'row_idx')), ...
		[ get(db, 'id') ' joined with ' get(with_db, 'id')], db.props);
