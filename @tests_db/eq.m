function rows = eq(db, row)

% eq - Equality (==) operator. Returns logical indices of db rows 
%	that match with given row.
%
% Usage:
% rows = eq(db, row)
%
% Description:
%
%   Parameters:
%	db: A tests_db object.
%	row: Row array to be compared with db rows.
%		
%   Returns:
%	rows: A logical or index vector to be used in indexing db objects. 
%
% See also: eq, tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/17

%# - find 0 rows in db
rows = ~ compareRows(db, row);
