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
%	a_tests_db: The db object of with the means on page 1 
%		    and standard deviations on page 2.
%
% See also: tests_db/mean, tests_db/std, sortedUniqueValues
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/30

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% TODO: add number column for each set and also mode, SD for each duplicate set.
main_cols = tests2cols(db, main_cols);
rest_cols = tests2cols(db, rest_cols);

% Find data within given columns
wo_cols = db.data(:, main_cols);

% Sort rows
[sorted idx] = sortrows(wo_cols);

% Find unique rows
[unique_rows unique_idx] = sortedUniqueValues(sorted);

% Get the columns back
sorted = db.data(idx, [main_cols rest_cols]);
sorted_db = onlyRowsTests(db, idx, [main_cols rest_cols]);

%sorted(:, 1:10)

col_names = fieldnames(sorted_db.col_idx);
num_cols = length(col_names);

% Initialize
num_rows = length(unique_idx);

data = repmat(NaN, [num_rows, length([main_cols rest_cols]) + 2]);

% For each unique row to next, take the mean
for row_num=1:num_rows
  if row_num < num_rows
    rows = unique_idx(row_num):(unique_idx(row_num + 1) - 1);
  else
    rows = unique_idx(row_num):size(sorted, 1);
  end

  rows_db = ...
      onlyRowsTests(sorted_db, rows, ...
		    (length(main_cols) + 1):(length(main_cols) + length(rest_cols)));
  no_mean_rows_db = onlyRowsTests(sorted_db, rows(1), 1:length(main_cols));
  new_vals = [length(rows), idx(rows(1))];
  new_row = [ get(no_mean_rows_db, 'data'), new_vals, get(mean(rows_db), 'data') ];
  new_std = [ get(no_mean_rows_db, 'data'), new_vals, get(std(rows_db), 'data') ];
  %displayRows(rows_db(:, 'NeuronId'))

  % Write row in place
  data(row_num, :, 1) = new_row;
  data(row_num, :, 2) = new_std;
end

col_names = { col_names{1:length(main_cols)}, 'NumDuplicates', 'RowIndex', ...
              col_names{(length(main_cols) + 1):end}};

% Update the fields of the new database object
a_tests_db = set(sorted_db, 'data', data);
a_tests_db = set(a_tests_db, 'col_idx', makeIdx(col_names));
a_tests_db = set(a_tests_db, 'id', ['averaged ' a_tests_db.id]);
