function rows = le(db, row)

% le - Less or equal (<=) operator. Returns logical indices of db rows 
%	that are less than or equal to given row.
%
% Usage:
% rows = le(db, row)
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
% See also: le, tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/17

comparison = compareRows(db, row)
rows = comparison < 0 | comparison == 0;

