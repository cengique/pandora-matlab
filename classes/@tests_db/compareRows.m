function [idx, compared] = compareRows(db, row)

% compareRows - Returns comparison results of db and the given row in a column vector.
%
% Usage:
% idx = compareRows(db, row)
%
% Description:
% If the row argument has multiple rows, the comparison is done separately
% for each of its rows and the results are the logical AND of those.
% Note that, it uses summation of distance for magnitude comparison. 
% That is, all columns have the same weight. If the db contains many
% columns and one row, then the columns are compared instead of rows.
%
%   Parameters:
%	db: A tests_db object.
%	row: Row array, matrix or database to be compared with db rows.
%		
%   Returns:
%	idx: A inverted logical column vector of comparison results. 
%		(false if db == row, true otherwise)
%
% See also: eq, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/17

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

%# Compare two dbs?
if isa(row, 'tests_db')
  row = row.data;
end

% flip to do columns instead of rows
if dbsize(db, 2) > dbsize(db, 1) && dbsize(db, 1) == 1
  db = transpose(db);
end

if dbsize(db, 2) ~= size(row, 2)
  error('Row must contain same columns as the db.');
end

%# prepare variables for faster processing
num_rows = size(row, 1);
num_db_rows = dbsize(db, 1);
ones_matx = ones(num_db_rows, 1);
idx = true(num_db_rows, 1);

%# Calculate multiple rows by tail recursion function 
% TODO: remove function call to speed it up
for row_num=1:num_rows
  %# Find doesn't work in two dimension comparisons
  %# Thus, use algorithm:

  %# - duplicate row to a matrix of same size with db
  %# - subtract from db
  compared = db.data - (ones_matx * row(row_num, :));

  idx = idx & (sum(abs(compared), 2) > eps(0));
end

end