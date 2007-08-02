function a_db = noNaNRows(a_db)

% noNaNRows - Returns a DB by removing rows containing any NaN or Inf.
%
% Usage:
% a_db = noNaNRows(a_db)
%
% Description:
%
%   Parameters:
%	a_db: A tests_db object.
%		
%   Returns:
%	a_db: DB with missing rows.
%
% See also: tests_db/isnanrows
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/09/21

a_db = onlyRowsTests(a_db, ~ isnanrows(a_db) & ~ isinf(a_db), ':');
