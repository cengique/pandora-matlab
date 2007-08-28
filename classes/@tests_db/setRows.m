function obj = setRows(obj, rows)

% setRows - Sets the rows of observations in tests_db.
%
% Usage:
% index = setRows(obj, rows)
%
% Description:
%   Sets a new set of observations to the database and returns the new DB.
%
%   Parameters:
%	obj: A tests_db object.
%	rows: A matrix that contains rows for the DB.
%		
%   Returns:
%	obj: The tests_db object with the new rows.
%
% See also: allocateRows, addRow, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/08

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if dbsize(obj, 1) ~= 0 || dbsize(obj, 2) ~= 0
  error(['Database is not empty! This operation erases ', ...
	 'all contents of the DB.']);
end

obj.data = rows;
