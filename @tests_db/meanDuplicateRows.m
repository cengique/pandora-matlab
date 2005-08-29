function a_tests_db = meanDuplicateRows(db, main_cols, rest_cols)

% meanDuplicateRows - Row-reduces a db by finding sets of rows with same main_cols values, and replacing each set with a single row containing main_cols and the mean of rest_cols.
%
% Usage:
% a_tests_db = meanDuplicateRows(db, main_cols, rest_cols)
%
% Description:
%   The database is sorted for the values of the columns of 
% interest (main_cols) and all rows with duplicate values of 
% these columns are identified. The rest of the columns (rest_cols) 
% are averaged and reduced to a single row, and attached to the
% nominal values of main_cols. Two additional parameter columns will be added to the
% database created. The NumDuplicates column is the the number of duplicates 
% used in the mean operation, and RowIndex is the row number points 
% to the first of a set of duplicate values.
%
%   Parameters:
%	db: A tests_db object.
%	main_cols: Vector of columns in which to find duplicates.
%	rest_cols: Vector of columns to be averaged for duplicate main_cols.
%		
%   Returns:
%	a_tests_db: A tests_3D_db object of organized values.
%
% See also: tests_3D_db, tests_3D_db/corrCoefs, tests_3D_db/plotPair
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/30

%# TODO: add number column for each set and also mode, SD for each duplicate set.
main_cols = tests2cols(db, main_cols);
rest_cols = tests2cols(db, rest_cols);

%# Find data within given columns
wo_cols = db.data(:, main_cols);

%# Sort rows
[sorted idx] = sortrows(wo_cols);

%# Find unique rows
[unique_rows unique_idx] = sortedUniqueValues(sorted)

%# Get the columns back
sorted = db.data(idx, [main_cols rest_cols]);
sorted_db = onlyRowsTests(db, idx, [main_cols rest_cols]);

%#sorted(:, 1:10)

col_names = fieldnames(sorted_db.col_idx);
num_params = get(sorted_db, 'num_params');
num_cols = length(col_names);

%# Initialize
num_rows = length(unique_idx);

data = repmat(NaN, [num_rows, length([main_cols rest_cols]) + 2]);

%# For each unique row to next, take the mean
for row_num=1:num_rows
  if row_num < num_rows
    rows = unique_idx(row_num):(unique_idx(row_num + 1) - 1);
  else
    rows = unique_idx(row_num):size(sorted, 1);
  end

  rows_db = onlyRowsTests(sorted_db, rows, ':');
  new_row = mean(rows_db);
  new_vals = [length(rows), idx(rows(1))];
  %#displayRows(rows_db(:, 'NeuronId'))

  %# Insert new values as parameters
  if num_cols > num_params
    new_row = [new_row(1:num_params) new_vals new_row((num_params + 1):num_cols)];
  else
    new_row = [new_row new_vals];
  end

  %# Write row in place
  data(row_num, :) = new_row;
end


if num_cols > num_params
  col_names = {col_names{1:num_params}, 'NumDuplicates', 'RowIndex', ...
	       col_names{(num_params + 1): num_cols}};
else
  col_names = {col_names{:}, 'NumDuplicates', 'RowIndex'};
end

%# Update the fields of the new database object
a_tests_db = set(sorted_db, 'data', data);
a_tests_db = set(a_tests_db, 'col_idx', makeIdx(col_names));
a_tests_db = set(a_tests_db, 'num_params', num_params + 2);
a_tests_db = set(a_tests_db, 'id', ['averaged ' a_tests_db.id]);
