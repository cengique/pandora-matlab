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
% index can be used to find the test values that are omitted.
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
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/30

vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

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

%# If not symmetric
if mod(size(sorted, 1), num_rows) ~= 0
  if ~ exist('main_cols')
    error('Database does not contain equal rows of each unique combination and main_cols is not specified. Cannot fold.');
  end

  main_cols = tests2cols(db, main_cols);

  %# Assert main_cols are included in cols
  if ~ all(ismember(main_cols, cols))
    error('main_cols should be included in cols.');
  end

  %# Sort and keep the unique values of main_cols
  unique_main_vals = sort(uniqueValues(sorted(:, main_cols)));
  if verbose
    unique_main_vals
  end
  num_uniques = size(unique_main_vals, 1);
  max_page_rows = num_uniques;
else
  max_page_rows = floor(size(sorted, 1) / num_rows);
end

data = repmat(NaN, [max_page_rows, (length(cols) + 1), num_rows]);

%# For each unique row to next, create a new page
for row_num=1:num_rows
  if row_num < num_rows
    page_rows = unique_idx(row_num):(unique_idx(row_num + 1) - 1);
  else
    page_rows = unique_idx(row_num):size(sorted, 1);
  end

  page_size = length(page_rows);
  if exist('unique_main_vals')
    %# sort main_cols first
    [page_main_vals page_idx] = sortrows(sorted(page_rows, main_cols));

    %# Match each page entry to uniques
    unique_index = 1;
    for page_index = 1:page_size
      unique_index = find(page_main_vals(page_index) == unique_main_vals);

      %# Check for errors
      if num_uniques - unique_index < page_size - page_index
	page_main_vals
	error('Fatal: cannot match within page values of main_cols to uniques?');
      end

      %# Check if remaining page size is equal to remaining uniques size,
      %# if so just copy the rest of the page.
      if page_size - page_index == num_uniques - unique_index
	%# Copy contents verbatim from this index onwards
	data(unique_index:end, :, row_num) = ...
	  [sorted(page_rows(page_idx(page_index:end)), cols), ...
	   idx(page_rows(page_idx(page_index:end))) ];
      else
	%# Copy only this row
	data(unique_index, :, row_num) = ...
	    [sorted(page_rows(page_idx(page_index)), cols), ...
	     idx(page_rows(page_idx(page_index))) ];
      end
    end
  else
    %# Fill page from fixed-size unique values
    data(:, :, row_num) = [sorted(page_rows, cols), idx(page_rows) ];
  end
end

%# Create the 3D database
col_name_cell = fieldnames(db.col_idx);
col_names = col_name_cell(cols);

%# TODO: put the invarName in the title?
a_tests_3D_db = tests_3D_db(data, {col_names{:}, 'RowIndex'}, {}, {}, ...
			    [ 'Invariant values from ' db.id ], get(db, 'props'));
