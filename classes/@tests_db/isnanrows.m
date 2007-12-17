function rows = isnanrows(db)

% isnanrows - Finds rows with any NaN values. Returns logical indices of db rows.
%
% Usage:
% rows = isnanrows(db)
%
% Description:
%   Some operations need that no NaN values exist in the matrix. This method
% can be used to find and then remove NaN-contaminated rows from DB. Note
% that sometimes no rows can  be found, and some columns should be discarded
% before this operation.
%
%   Parameters:
%	db: A tests_db object.
%		
%   Returns:
%	rows: A logical vector to be used in indexing db objects or passed
%		through other logical operators. 
%
% See also: isnan, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/11/08

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ndims(db.data) > 2 
  error('Cannot work in three dimensions.');
end

% Find all rows with any NaNs in them
rows = any(isnan(db.data), 2);
