function a_db = vertcat(db, varargin)

% vertcat - Vertical concatanation [db;with_db;...] operator.
%
% Usage:
% a_db = vertcat(db, with_db, ...)
%
% Description:
%   Concatanates rows of with_db to rows of db. Overrides the built-in
% vertcat function that is called when [db;with_db] is executed. If the 
% first argument is a array of DBs, then this functionality is not needed;
% built-in vertcat is called.
%
%   Parameters:
%	db: A tests_db object.
%	with_db: A tests_db object whose rows are concatanated to db.
%		
%   Returns:
%	a_db: A tests_db that contains rows of db and with_db.
%
% See also: vertcat, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/01/25

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% if input is already a row of DBs, allow building a DB matrix
if length(db) > 1
  a_db = builtin('vertcat', db, varargin{:});
else

% Recurse to support variable number of inputs
if length(varargin) > 1
  with_db = vertcat(varargin{1}, varargin{2:end});
elseif length(varargin) == 0
  a_db = db;
  return;
else
  with_db = varargin{1};
end

% return the other one if one of the dbs is empty
if prod(dbsize(db)) == 0
  a_db = with_db;
  return;
elseif prod(dbsize(with_db)) == 0
  a_db = db;
  return;
end

% check for column consistency
[col_names, wcol_names] = checkConsistentCols(db, with_db);

% concatenate and preserve column order of first DB
a_db = set(db, 'data', [ get(db, 'data'); ...
			get(onlyRowsTests(with_db, ':', col_names), 'data') ] );
end