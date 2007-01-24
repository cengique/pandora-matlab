function [col_names, with_col_names] = checkConsistentCols(db, with_db)

% checkConsistentCols - Check if two DBs have exactly the same columns.
%
% Usage:
% [col_names, with_col_names] = checkConsistentCols(db, with_db)
%
% Description:
%
%   Parameters:
%	db: A tests_db object.
%	with_db: A tests_db object whose column names are checked for consistency.
%		
%   Returns:
%	col_names, with_col_names: list of column names of each DB.
%
% See also: vertcat, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2007/01/18

col_names = getColNames(db);
with_col_names = getColNames(with_db);

%# Check if they have same columns
if dbsize(db, 2) ~= dbsize(with_db, 2) || ... %# Same number of columns
  ((~ isempty(col_names) || ~ isempty(with_col_names)) && ... %# If any names are specified,
   ~ all(ismember(col_names, with_col_names))) 	          %# make sure they're same 
  error('Need to have same columns with same names in db and with_db.');
end
