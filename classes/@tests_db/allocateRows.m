function obj = allocateRows(obj, num_rows)

% allocateRows - Preallocates a NaN-filled num_rows rows in tests_db.
%
% Usage:
% obj = allocateRows(obj, num_rows)
%
% Description:
%   Allocates the desired number of rows to speed up filling up the data matrix 
%   using assignRowsTests. Using addRow after this operation is still expensive.
%   The method of allocating a matrix, filling it up, and then providing it to 
%   the tests_db constructor is the preferred method of creating tests_db objects.
%
%   Parameters:
%	obj: A tests_db object.
%	num_rows: The predicted number of observations for this tests_db.
%		
%   Returns:
%	obj: The new tests_db object.
%
% See also: assignRowsTests, addRow, setRows, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/08

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

if dbsize(obj, 1) ~= 0 && dbsize(obj, 2) ~= 0
  error(['Database is not empty! This operation erases ', ...
	 'all contents of the DB.']);
end

obj.data = repmat(NaN, num_rows, length(fieldnames(obj.col_idx)));
