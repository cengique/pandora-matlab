function a_tests_3D_db = invarValues(db, cols, in_page_unique_cols)

% invarValues - Finds all sets in which given columns vary while the rest are invariant.
%
% Usage:
% a_tests_3D_db = invarValues(db, cols, in_page_unique_cols)
%
% Description:
%   Useful when trying to find relationships between some columns
% independent of other columns. In a database that contains results of a
% multivariate function, this function can find the effect of one or more
% parameters when other parameters are kept constant (i.e., invariant). Rows
% with the values of the desired columns are separated into the pages of a
% tests_3D_db for each unique set of the other column values. These
% invariant values of the other columns are missing from the resulting
% tests_3D_db, instead a RowIndex is kept pointing to the db in which they
% can be found. See joinRows for joining the results back with the invariant
% columns.
%   In databases that contain all unique combinations of certain parameters,
% the resulting 3D database becomes symmetric. This function row-sorts the
% database to ensure that each page has the same parameter values in the
% same rows. This is important because when the rows and pages of database
% is swapped (see tests_3D_db/swapRowsPages) each page has the same value of
% the in_page_unique_cols variables. Other functions such as
% tests_3D_db/mergePages also depend on this property.
%   However, for databases with missing combinations, in_page_unique_cols
% specifies which columns is used to guide which rows of the page to place
% values found. This function will fail if you do not have such a column.
% Note: the trial column will be ignored before finding invariant values.
%
%   Parameters:
%	db: A tests_db object.
%	cols: Vector of column numbers to find values when others are
%		invariant. Include result columns here.
%	in_page_unique_cols: Vector of columns that have the same unique values in each page 
% 		(Optional; used only if database is not symmetric, to ignore 
%		missing values of in_page_unique_cols)
%		
%   Returns:
%	a_tests_3D_db: A tests_3D_db object of organized values.
%
% Example:
% >> a_db = tests_db([ ... ], {'par1', 'par2', 'measure1', 'measure2'})
% % make a page for each value of par1, and list par2 values with assoc. measures:
% >> a_3d_db = invarValues(a_db, [2:4], 'par2')
% >> displayRows(a_3d_db(:, :, 1))
%
% See also: tests_3D_db, tests_3D_db/corrCoefs, tests_3D_db/plotPair,
% 	    joinRows, tests_3D_db/swapRowsPages, tests_3D_db/mergePages
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

% Remove trial column from parameters that define character of data
test_names = fieldnames(get(db, 'col_idx'));
trial_col = strmatch('trial', test_names);

% Remove all given columns, left with surrounding parameters
log_cols = false(1, dbsize(db, 2));
log_cols(cols) = true(1);
log_cols(trial_col) = true(1);
wo_cols = db.data(:, ~log_cols);

% Sort rows
[sorted idx] = sortrows(wo_cols);

% Find unique rows
[unique_rows unique_idx] = sortedUniqueValues(sorted);

% Get the columns back [no need for duplicate memory matrix, just use idx below]
% sorted = db.data(idx, :);

% Initialize
num_rows = length(unique_idx);
num_total_rows = dbsize(db, 1);

% If not symmetric
if mod(num_total_rows, num_rows) ~= 0
  if verbose
    disp('Warning: non-symmetric database.');
  end
  if ~ exist('in_page_unique_cols')
    error('Database does not contain equal rows of each unique combination and in_page_unique_cols is not specified. Cannot fold.');
  end

  in_page_unique_cols = tests2cols(db, in_page_unique_cols);

  % Sort and keep the unique values of in_page_unique_cols
  unique_main_vals = sortrows(uniqueValues(db.data(idx, in_page_unique_cols)));
  num_uniques = size(unique_main_vals, 1);
  if verbose
    unique_main_vals
    num_uniques
    num_rows
  end
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

% For each unique row to next, create a new page
for row_num=1:num_rows
  if row_num < num_rows
    page_rows = unique_idx(row_num):(unique_idx(row_num + 1) - 1);
  else
    page_rows = unique_idx(row_num):num_total_rows;
  end

  page_size = length(page_rows);
  if unique_main_vals_exist
    % sort in_page_unique_cols first
    [page_main_vals page_idx] = sortrows(db.data(idx(page_rows), in_page_unique_cols));

    % Match each page entry to uniques
    unique_index = 1;
    for page_index = 1:page_size
      unique_index = findVectorInMatrix(unique_main_vals, ...
					page_main_vals(page_index, :));

      % Check for errors
      if num_uniques - unique_index < page_size - page_index
	num_uniques
	unique_index
	page_size
	page_index
	page_main_vals
	error(['Fatal: cannot match within page values of in_page_unique_cols? ' ...
               'See above variables.']);
      end

      % Check if remaining page size is equal to remaining uniques size,
      % if so just copy the rest of the page.
      if page_size - page_index == num_uniques - unique_index
	% Copy contents verbatim from this index onwards
	data(unique_index:end, :, row_num) = ...
	  [db.data(idx(page_rows(page_idx(page_index:end))), cols), ...
	   idx(page_rows(page_idx(page_index:end))) ];
      else
	% Copy only this row
	data(unique_index, :, row_num) = ...
	    [db.data(idx(page_rows(page_idx(page_index))), cols), ...
	     idx(page_rows(page_idx(page_index))) ];
      end
    end
  else
    % Fill page from fixed-size unique values
    this_page_idx = idx(page_rows);
    data(:, :, row_num) = [db.data(this_page_idx, cols), this_page_idx ];
  end
end

% Create the 3D database
col_name_cell = fieldnames(db.col_idx);
col_names = col_name_cell(cols);

% TODO: put the invarName in the title?
a_tests_3D_db = tests_3D_db(data, {col_names{:}, 'RowIndex'}, {}, {}, ...
			    [ 'Invariant values from ' db.id ], get(db, 'props'));
