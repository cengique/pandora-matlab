function obj = addParams(obj, param_names, param_columns)

% addParams - Inserts new parameter columns to tests_db.
%
% Usage:
% obj = addParams(obj, param_names, param_columns)
%
% Description:
%   Adds new columns to the database and returns the new DB.
%   This operation is expensive in the sense that the whole database matrix
%   needs to be enlarged just to add a 
%   single new column. The method of allocating a matrix, filling it up, and
%   then providing it to the tests_db constructor is the preferred method 
%   of creating tests_db objects. This method may be used for 
%   measures obtained by operating on raw measures.
%
%   Parameters:
%	obj: A tests_db object.
%	param_names: A cell array of param names to be added.
%	param_columns: Data matrix of columns to be added.
%		
%   Returns:
%	obj: The tests_db object that includes the new columns.
%
% See also: allocateRows, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/10/11

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if (dbsize(obj, 1) > 0 && size(param_columns, 1) ~= dbsize(obj, 1))
  error(['Number of rows in column (' num2str(size(param_columns, 1)) ') ', ...
	 'does not match rows in DB (' num2str(dbsize(obj, 1)) ').']);
end

if length(param_names) ~= size(param_columns, 2)
  error(['Number of parameter names (' num2str(length(param_names)) ') ', ...
	 'does not match columns in matrix (' num2str(size(param_columns, 2)) ').']);
end

num_params = get(obj, 'num_params');

% Add the column to the parameter DB
a_param_db = addColumns(onlyRowsTests(obj, ':', 1:num_params), ...
			param_names, param_columns);

% Concat the rest of original DB 
a_test_db = onlyRowsTests(obj, ':', (num_params + 1):dbsize(obj, 2));
if dbsize(a_test_db, 2) > 0
  obj = addColumns(a_param_db, fieldnames(get(a_test_db, 'col_idx')), ...
                   get(a_test_db, 'data'));
else
  obj = a_param_db;
end

% Adjust number of params
obj.num_params = num_params + length(param_names);