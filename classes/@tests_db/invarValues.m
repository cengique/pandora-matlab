function a_tests_3D_db = invarValues(db, cols, main_cols)

% invarValues - Generates a 3D database of invariant values of given columns.
%
% Usage:
% a_tests_3D_db = invarValues(db, cols, main_cols)
%
% Description:
% The invariant values of a column are its values when all other 
% column values are fixed. The invariant values of desired columns
% forms a matrix of rows. This function finds all combinations of the
% rest of the columns and returns the invariant value matrices 
% for each such combination in a page of a three-dimensional vector; 
% i.e. a tests_3D_db. Each matrix page will contain an additional 
% column for the original row index for the invariant values. This
% index can be used to find the test columns that were omitted.
% Note: the trial column will be ignored for finding invariant values.
%
%   Parameters:
%	db: A tests_db object.
%	cols: Vector of column numbers to find invariant values.
%	main_cols: Vector of columns that need to be unique in each page 
% 		(Optional; used only if database is not symmetric, to ignore 
%		missing values of main_cols)
%		
%   Returns:
%	a_tests_3D_db: A tests_3D_db object of organized values.
%
% See also: tests_3D_db, tests_3D_db/corrCoefs, tests_3D_db/plotPair
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/30

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

cols = tests2cols(db, cols);

%# Remove trial column from parameters that define character of data
test_names = fieldnames(get(db, 'col_idx'));
trial_col = strmatch('trial', test_names);

%# Remove all given columns, left with surrounding parameters
log_cols = false(1, dbsize(db, 2));
log_cols(cols) = true(1);
log_cols(trial_col) = true(1);
wo_cols = db.data(:, ~log_cols);

%# Sort rows
[sorted idx] = sortrows(wo_cols);

%# Find unique rows
[unique_rows unique_idx] = sortedUniqueValues(sorted);

%# Get the columns back [no need for duplicate memory matrix, just use idx below]
%# sorted = db.data(idx, :);

%# Initialize
num_rows = length(unique_idx);
num_total_rows = dbsize(db, 1);

%# If not symmetric
if mod(num_total_rows, num_rows) ~= 0
  if verbose
    disp('Warning: non-symmetric database.');
  end
  if ~ exist('main_cols')
    error('Database does not contain equal rows of each unique combination and main_cols is not specified. Cannot fold.');
  end

  main_cols = tests2cols(db, main_cols);

  %# Sort and keep the unique values of main_cols
  unique_main_vals = sortrows(uniqueValues(db.data(idx, main_cols)));
  if verbose
    unique_main_vals
  end
  num_uniques = size(unique_main_vals, 1);
  max_page_rows = num_uniques;
else
  max_page_rows = floor(num_total_rows / num_rows);
end

data = repmat(NaN, [max_page_rows, (length(cols) + 1), num_rows]);

if exist('unique_main_vals')
  unique_main_vals_exist = true;
else
  unique_main_vals_exist = false;
end

%# For each unique row to next, create a new page
for row_num=1:num_rows
  if row_num < num_rows
    page_rows = unique_idx(row_num):(unique_idx(row_num + 1) - 1);
  else
    page_rows = unique_idx(row_num):num_total_rows;
  end

  page_size = length(page_rows);
  if unique_main_vals_exist
    %# sort main_cols first
    [page_main_vals page_idx] = sortrows(db.data(idx(page_rows), main_cols));

    %# Match each page entry to uniques
    unique_index = 1;
    for page_index = 1:page_size
      unique_index = findVectorInMatrix(unique_main_vals, ...
					page_main_vals(page_index, :));

      %# Check for errors
      if num_uniques - unique_index < page_size - page_index
	num_uniques
	unique_index
	page_size
	page_index
	page_main_vals
	error('Fatal: cannot match within page values of main_cols to uniques?');
      end

      %# Check if remaining page size is equal to remaining uniques size,
      %# if so just copy the rest of the page.
      if page_size - page_index == num_uniques - unique_index
	%# Copy contents verbatim from this index onwards
	data(unique_index:end, :, row_num) = ...
	  [db.data(idx(page_rows(page_idx(page_index:end))), cols), ...
	   idx(page_rows(page_idx(page_index:end))) ];
      else
	%# Copy only this row
	data(unique_index, :, row_num) = ...
	    [db.data(idx(page_rows(page_idx(page_index))), cols), ...
	     idx(page_rows(page_idx(page_index))) ];
      end
    end
  else
    %# Fill page from fixed-size unique values
    this_page_idx = idx(page_rows);
    data(:, :, row_num) = [db.data(this_page_idx, cols), this_page_idx ];
  end
end

%# Create the 3D database
col_name_cell = fieldnames(db.col_idx);
col_names = col_name_cell(cols);

%# TODO: put the invarName in the title?
a_tests_3D_db = tests_3D_db(data, {col_names{:}, 'RowIndex'}, {}, {}, ...
			    [ 'Invariant values from ' db.id ], get(db, 'props'));
