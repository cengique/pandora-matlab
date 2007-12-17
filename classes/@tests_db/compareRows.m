function [idx, compared] = compareRows(db, rows)

% compareRows - Returns differing rows of db and the given row(s).
%
% Usage:
% [idx, compared] = compareRows(db, rows)
%
% Description:
% It can compare all db rows to corresponding row entries or to a single
% row. For the case with only one entry, returns all db rows that do not
% match the given row in idx, and the result of the differences in
% compared. For the case of multiple rows, rows must have exactly same number
% of rows with db. In both cases, idx must be negated to test for equality.
%
% Parameters:
%	db: A tests_db object.
%	rows: Row array, matrix or database to be compared with db rows.
%		
% Returns:
%	idx: A inverted logical column vector of comparison results. 
%		(false if db == rows, true otherwise)
%	compared: A column vector of differences of each DB row to the
% 		given row (i.e., compared = db - rows).
%
% Example:
%  >> db(db(:, 'trial') > [12]), :)
% calls gt which calls compareRows to check for equality. Returns a db
% only containing rows with trial numbers greater than 12.
%
% See also: eq, anyRows, ge, gt, le, lt, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/17

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Compare two dbs?
if isa(rows, 'tests_db')
  rows = rows.data;
end

% faster?
db_data = db.data;

% sanity checks
if dbsize(db, 2) ~= size(rows, 2)
  error(['Rows contains ' num2str(size(rows, 2)) ' columns, but db has ' ...
         num2str(dbsize(db, 2)) ' columns. They must match for comparison.']);
end

% prepare variables for faster processing
num_rows = size(rows, 1);
num_db_rows = size(db_data, 1);
ones_matx = ones(num_db_rows, 1);
idx = true(num_db_rows, 1);

if num_rows ~= 1 && num_db_rows ~= num_rows
  error(['db and rows should contain same number of rows or db must be ' ...
         'compared to a single row. Currently rows contains ' num2str(num_rows) ...
         ' rows, but db has ' num2str(num_db_rows) ' rows. See anyRows if' ...
         ' you''re looking to find db rows matching any given row.']);
end

if num_rows == 1
  row_data = ones_matx * rows;
else
  row_data = rows;
end

% Find doesn't work in two dimension comparisons
% Thus, use algorithm:

% - duplicate rows to a matrix of same size with db
% - subtract from db
compared = db_data - row_data;

% matching rows become zero
idx = idx & (any(abs(compared) > eps(0), 2));

% don't consider any NaN-containing rows
idx = idx | any(isnan(rows), 2) | any(isnan(db_data), 2);

end