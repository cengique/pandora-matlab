function [rows, compared] = compareRows(db, row)

% compareRows - Returns comparison results of db and the given row in a column vector.
%
% Usage:
% rows = compareRows(db, row)
%
% Description:
% If the row argument has multiple rows, the comparison is done separately
% for each of its rows and the results are the logical OR of those.
% Note that, it uses summation of distance for magnitude comparison. 
% That is, all columns have the same weight.
%
%   Parameters:
%	db: A tests_db object.
%	row: Row array, matrix or database to be compared with db rows.
%		
%   Returns:
%	rows: A column vector of comparison results. 
%		(<0: db < row, 0: db == row, >0: db > row)
%
% See also: eq, tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/17

%# Compare two dbs?
if isa(row, 'tests_db')
  row = row.data;
end

if dbsize(db, 2) ~= size(row, 2)
  error('Row must contain same columns as the db.');
end

%# If multiple rows in row
if size(row, 1) > 1
  %# recurse
  rows = compareRows(db, row(1, 1)) & compareRows(db, row(2:end, 1));
  compared = NaN;
else
  %# Find doesn't work in two dimension comparisons
  %# Thus, use algorithm:

  %# - duplicate row to a matrix of same size with db
  row_matx = ones(dbsize(db, 1), 1) * row;

  %# - subtract from db
  compared = db.data - row_matx;

  rows = sum(compared, 2) ~= 0;
end
