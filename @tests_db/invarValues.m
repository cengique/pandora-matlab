function a_tests_3D_db = invarValues(db, cols)

% invarValues - Generates a 3D database of invariant values of given columns.
%
% Usage:
% a_tests_3D_db = invarValues(db, cols)
%
% Description:
% The invariant values of a column are its values when all other 
% column values are fixed. The invariant values of desired columns
% forms a matrix of rows. This function finds all combinations of the
% rest of the columns and returns the invariant value matrices 
% for each such combination in a page of a three-dimensional vector; 
% i.e. a tests_3D_db. Each matrix page will contain an additional 
% column for the original row index for the invariant values. This
% index can be used to find the test values that are omitted.
%
%   Parameters:
%	db: A tests_db object.
%	cols: Vector of column numbers to find invariant values.
%		
%   Returns:
%	a_tests_3D_db: A tests_3D_db object of organized values.
%
% See also: tests_3D_db, tests_3D_db/corrCoefs, tests_3D_db/plotPair
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/30

cols = tests2cols(db, cols);

%# Remove given columns
log_cols = false(1, dbsize(db, 2));
log_cols(cols) = true(1);
wo_cols = db.data(:, ~log_cols);

%# Sort rows
[sorted idx] = sortrows(wo_cols);

%# Find unique rows
[unique_rows unique_idx] = sortedUniqueValues(sorted);

%# Get the columns back
sorted = db.data(idx, :);

%# Initialize
num_rows = length(unique_idx);
page_rows = floor(size(sorted, 1) / num_rows);

if mod(size(sorted, 1), num_rows) ~= 0
  error('Database does not contain equal rows of each unique combination. Cannot fold.');
end

data = repmat(NaN, [page_rows, (length(cols) + 1), num_rows]);

%# For each unique row to next, create a new page
for row_num=1:num_rows
  if row_num < num_rows
    rows = unique_idx(row_num):(unique_idx(row_num + 1) - 1);
  else
    rows = unique_idx(row_num):size(sorted, 1);
  end

  %# Fill page
  data(:, :, row_num) = [sorted(rows, cols), idx(rows) ];
end

%# Create the 3D database
col_name_cell = fieldnames(db.col_idx);
col_names = col_name_cell(cols);

%# TODO: put the invarName in the title?
a_tests_3D_db = tests_3D_db(data, {col_names{:}, 'RowIndex'}, {}, {}, ...
			    [ 'Invariant values from ' db.id ], get(db, 'props'));
