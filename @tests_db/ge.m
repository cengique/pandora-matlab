function rows = ge(db, row)

% ge - Greater or equal to (>=) operator. Returns logical indices of db rows 
%	that are greater than or equal to given row.
%
% Usage:
% rows = ge(db, row)
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
% See also: ge, tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/17

comparison = compareRows(db, row)
rows = comparison > 0 | comparison == 0;
