function a_db = joinRows(db, tests, with_db, w_tests, index_col_name)

% joinRows - Joins the rows of the given db with rows of with_db with matching
%  	RowIndex values.
%
% Usage:
% a_db = joinRows(db, tests, with_db, w_tests, index_col_name)
%
% Description:
%   Takes the desired columns in with_db with rows having a 
% row index and joins them next to desired columns from the current db. 
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
%	a_db: A tests_db object.
%
% See also: tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/16

data = get(db, 'data');
w_data = get(with_db, 'data');

if ~ exist('index_col_name')
  index_col_name = 'RowIndex';
end

vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

join_col = tests2cols(with_db, index_col_name);
joins = w_data(:, join_col);

if any(isnan(joins))
  if verbose
    warning(['NaNs in ' index_col_name ' column. Proceeding with caution.']);
  end

  %# Find all RowIndex columns
  row_index_cols = strmatch('RowIndex', fieldnames(get(with_db, 'col_idx')));

  %# Then look for missing values in other columns
  all_joins = w_data(:, row_index_cols);
  all_non_nans = ~isnan(all_joins);
  for joins_row = 1:size(all_joins, 1)
    tmp_j = all_joins(joins_row, all_non_nans(joins_row, :));
    joins(joins_row) = tmp_j(1);
  end
end

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
a_db = set(db, 'data', new_data);
a_db = set(a_db, 'col_idx', makeIdx({ cols_cell1{cols}, cols_cell2{w_cols} }));
a_db = set(a_db, 'id', [ get(db, 'id') ' joined with ' get(with_db, 'id')]);
