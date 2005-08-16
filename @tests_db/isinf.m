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
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/08/16

if ~ exist('col')
  col = 1;
end

col = tests2cols(db, col);

col_db = onlyRowsTests(db, ':', col);

rows = isinf(col_db.data);
