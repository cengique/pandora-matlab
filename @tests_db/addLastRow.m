function obj = addLastRow(obj, row)

% addLastRow - Inserts a row of observations at the end of tests_db.
%
% Usage:
% index = addLastRow(obj, row)
%
% Description:
%   Adds a new set of observations to the database and returns its row index.
%   This operation is expensive because the whole 
%   database matrix needs to be duplicated and resized in order to add a 
%   single new row. The method of allocating a matrix, filling it up, and
%   then providing it to the tests_db constructor is the preferred method 
%   of creating tests_db objects.
%
%   Parameters:
%	obj: A tests_db object.
%	row: A row vector that contains values for each DB column.
%		
%   Returns:
%	obj: The tests_db object that includes the new row.
%
% See also: allocateRows, addRow, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/08

if size(row, 2) ~= dbsize(obj, 2)
  error(['Number of columns in row (' num2str(size(row, 2)) ') ', ...
	 'does not match columns in DB (' num2str(dbsize(obj, 2)) ').']);
end

obj.data = [obj.data; row];