function obj = allocateRows(obj, num_rows)

% allocateRows - Preallocates a NaN-filled num_rows rows in tests_db.
%
% Usage:
% index = allocateRows(obj, num_rows)
%
% Description:
%   Allocates the desired number of rows to speed up filling up the data 
%   matrix. Using addRow after this operation is still expensive.
%   The method of allocating a matrix, filling it up, and
%   then providing it to the tests_db constructor is the preferred method 
%   of creating tests_db objects.
%
%   Parameters:
%	obj: A tests_db object.
%	num_rows: The predicted number of observations for this tests_db.
%		
%   Returns:
%	obj: The new tests_db object.
%
% See also: addRow, setRows, tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/08

if dbsize(obj, 1) ~= 0 || dbsize(obj, 2) ~= 0
  error(['Database is not empty! This operation erases ', ...
	 'all contents of the DB.']);
end

obj.data = repmat(NaN, rows, length(fieldnames(obj.col_idx)));
