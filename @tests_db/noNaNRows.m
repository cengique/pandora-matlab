function a_db = noNaNRows(a_db)

% noNaNRows - Returns a DB by removing any NaN or Inf containing rows.
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
%	a_db: DB with rows with NaN values removed.
%
% See also: tests_db/isnanrows
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/09/21

a_db = onlyRowsTests(a_db, ~ isnanrows(a_db) & ~ isinf(a_db), ':');
