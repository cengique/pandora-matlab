function [col_names, with_col_names] = checkConsistentCols(db, with_db, props)

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
%	props: A structure with any optional properties.
%	  useCommon: Tolerate mismatching column names and only return
%	  	     the common columns.
%		
%   Returns:
%	col_names, with_col_names: list of column names of each DB.
%
% See also: vertcat, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2007/01/18

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

col_names = getColNames(db);
with_col_names = getColNames(with_db);

% Check if they have same columns
if dbsize(db, 2) ~= dbsize(with_db, 2) || ... % Same number of columns
  ((~ isempty(col_names) || ~ isempty(with_col_names)) && ... % If any names are specified,
   ~ all(ismember(col_names, with_col_names))) 	          % make sure they're same 
  
  if isfield(props, 'useCommon')
    % Choose common columns
    [common_cols, db_idx, w_db_idx] = ...
        intersect(col_names, with_col_names);
    % re-sort them accorging to left-hand-side DB
    common_cols = col_names(sort(db_idx));
    % return same for both
    [col_names, with_col_names] = deal(common_cols);
    % give a warning (TODO: make it optional?)
    warning(['DBs have mismatching columns, using lowest common denominator ' ...
             'columns.']);
  else
    error(['Need to have same columns with same names in db and ' ...
           'with_db.']);
  end
end
