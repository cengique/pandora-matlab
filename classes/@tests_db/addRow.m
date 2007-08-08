function obj = addRow(obj, row, index)

% addRow - Inserts a row of observations to tests_db at the given row index.
%
% Usage:
% index = addRow(obj, row, index)
%
% Description:
%   Adds a new set of observations to the database and returns the new DB.
%   This operation is expensive in the sense that the whole database matrix
%   needs to be copied to be passed to this function just to add a 
%   single new row. The method of allocating a matrix, filling it up, and
%   then providing it to the tests_db constructor is the preferred method 
%   of creating tests_db objects.
%
%   Parameters:
%	obj: A tests_db object.
%	row: A row vector that contains values for each DB column.
%	index: The row index.
%		
%   Returns:
%	obj: The tests_db object that includes the new row.
%
% See also: addLastRow, allocateRows, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/08

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

if (dbsize(obj, 1) > 0 && size(row, 2) ~= dbsize(obj, 2)) || ...
      size(row, 2) ~= length(fieldnames(obj.col_idx))
  error(['Number of columns in row (' size(row, 2) ') ', ...
	 'does not match columns in DB (' dbsize(obj, 2) ...
	 ', ' length(fieldnames(obj.col_idx)) ').']);
end

obj.data(index, :) = row;
