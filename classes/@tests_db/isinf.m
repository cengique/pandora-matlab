function rows = isinf(db, col)

% isinf - Returns logical row indices of Inf-valued columns.
%
% Usage:
% rows = isinf(db, col)
%
% Description:
%
%   Parameters:
%	db: A tests_db object.
%	col: Column to check (Optional, default = 1)
%		
%   Returns:
%	rows: A logical column vector of rows.
%
% See also: isinf, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/08/16

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

if ~ exist('col')
  col = 1;
end

col = tests2cols(db, col);

col_db = onlyRowsTests(db, ':', col);

rows = isinf(col_db.data);
