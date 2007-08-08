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

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

a_db = onlyRowsTests(a_db, ~ isnanrows(a_db) & ~ isinf(a_db), ':');
