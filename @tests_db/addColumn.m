function obj = addColumn(obj, test_name, test_column)

% addColumn - Inserts a row of observations to tests_db at the given row index.
%
% Usage:
% index = addColumn(obj, test_name, test_column)
%
% Description:
%   Adds a new test column to the database and returns the new DB.
%   This operation is expensive in the sense that the whole database matrix
%   needs to be enlarged just to add a 
%   single new column. The method of allocating a matrix, filling it up, and
%   then providing it to the tests_db constructor is the preferred method 
%   of creating tests_db objects. This method may be used for 
%   measures obtained by operating on raw measures.
%
%   Parameters:
%	obj: A tests_db object.
%	row: A row vector that contains values for each DB column.
%	index: The row index.
%		
%   Returns:
%	obj: The tests_db object that includes the new row.
%
% See also: allocateRows, tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2007/09/30

if (dbsize(obj, 1) > 0 && size(test_column, 1) ~= dbsize(obj, 1))
  error(['Number of rows in column (' size(test_column, 1) ') ', ...
	 'does not match rows in DB (' dbsize(obj, 1) ').']);
end

%# Add the column
new_col_id = dbsize(obj, 2) + 1;
obj.data(:, new_col_id) = test_column;

%# Update the meta-data
new_col_idx = get(obj, 'col_idx');
new_col_idx.(test_name) = new_col_id;

obj = set(obj, 'col_idx', new_col_idx);
