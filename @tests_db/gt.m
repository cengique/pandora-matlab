function rows = gt(db, row)

% gt - Greater than (>) operator. Returns logical indices of db rows 
%	that are greater than given row.
%
% Usage:
% rows = gt(db, row)
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
% See also: gt, tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/17

rows = compareRows(db, row) > 0;
