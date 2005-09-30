function rows = lt(db, row)

% lt - Less than (<) operator. Returns logical indices of db rows 
%	that are less than given row.
%
% Usage:
% rows = lt(db, row)
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
% See also: lt, tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/17

[rows comparison] = compareRows(db, row);
rows = comparison < 0;
