function rows = isnan(db, col)

% isnan - Returns logical row indices of NaN-valued columns.
%
% Usage:
% rows = isnan(db, col)
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
% See also: isnan, tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/06

if ~ exist('col')
  col = 1;
end

col = tests2cols(db, col);

col_db = onlyRowsTests(db, ':', col);

rows = isnan(col_db.data);
