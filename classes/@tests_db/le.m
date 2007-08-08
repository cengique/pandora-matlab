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
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/17

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

[rows comparison] = compareRows(db, row);
rows = comparison < 0 | comparison == 0;

