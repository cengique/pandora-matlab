function [idx rows_idx] = anyRows(db, rows)

% anyRows - Returns db rows matching any of the given rows.
%
% Usage:
% idx = anyRows(db, rows)
%
% Description:
% The db rows are compared to each row and row indices succeeding any of
% these comparisons are returned.
%
% Parameters:
%	db: A tests_db object.
%	rows: Row array, matrix or database to be compared with db rows.
%		
% Returns:
%	idx: A logical column vector of matching db row indices. 
%	rows_idx: Indices of rows entries corresponding to each db
%		row. Non-matching entries were left as NaN.
%
% Example:
%  >> db(anyRows(db(:, 'trial') == [12; 46; 37]), :)
% returns a db with rows having trial equal to any of the given values.
%
% See also: compareRows, eq, tests_db
%
% $Id: anyRows.m 809 2007-08-08 19:39:02Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/17

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% TODO: optimize by using sort

% Compare two dbs?
if isa(rows, 'tests_db')
  rows = rows.data;
end

% sanity check
if dbsize(db, 2) ~= size(rows, 2)
  error(['Rows contains ' num2str(size(rows, 2)) ' columns, but db has ' ...
         num2str(dbsize(db, 2)) ' columns. They must match for comparison.']);
end

% prepare variables for faster processing
num_rows = size(rows, 1);
num_db_rows = size(db.data, 1);
ones_matx = ones(num_db_rows, 1);
idx = false(num_db_rows, 1);
rows_idx = repmat(NaN, num_db_rows, 1);

db_data = db.data;

% DISABLED: look for optimization.
% unfortunately this is not even faster due to the memory requirement :(
if false && dbsize(db, 2) == 1 && num_db_rows * num_rows < 10000000
  idx = all(abs(( db.data * ones(1, num_rows) - (rows * ones_matx')')) <= ...
            eps(0), 2);
else

  % Calculate multiple rows by tail recursion
  for row_num=1:num_rows
    % Find doesn't work in two dimension comparisons
    % Thus, use algorithm:

    % - duplicate row to a matrix of same size with db
    % - subtract from db
    matching_db_rows = ...
        all(abs(db_data - (ones_matx * rows(row_num, :))) <= eps(0), 2);
    rows_idx(matching_db_rows) = row_num;
    idx = idx | matching_db_rows;
  end

end


end