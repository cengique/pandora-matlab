function compared = compareRows(db, row)

% compareRows - Returns comparison results of db and the given row
%		in a column vector.
%
% Usage:
% rows = compareRows(db, row)
%
% Description:
% Uses summation of distance for magnitude comparison. That is, all columns
% have the same weight.
%
%   Parameters:
%	db: A tests_db object.
%	row: Row array to be compared with db rows.
%		
%   Returns:
%	rows: A column vector of comparison results. 
%		(<0: db < row, 0: db == row, >0: db > row)
%
% See also: eq, tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/17

if size(db.data, 2) ~= size(row, 2)
  error('Row must contain same columns as the db.');
end

%# Find doesn't work in two dimension comparisons
%# Thus, use algorithm:

%# - duplicate row to a matrix of same size with db
row_matx = ones(size(db.data, 1), 1) * row;

%# - subtract from db
compared = db.data - row_matx;

rows = sum(compared, 2);
