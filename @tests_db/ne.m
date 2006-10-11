function rows = ne(db, row)

% ne - Returns logical indices of db rows that doesn't match with given row.
%
% Usage:
% rows = ne(db, row)
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
% See also: ne, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/17

rows = ~ eq(db, row);
