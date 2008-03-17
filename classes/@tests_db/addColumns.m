function obj = addColumns(obj, test_names, test_columns)

% addColumns - Inserts new columns to tests_db.
%
% Usage 1:
% obj = addColumns(obj, test_names, test_columns)
%
% Usage 2:
% obj = addColumns(obj, b_obj)
%
% Description:
%   Adds new test columns to the database and returns the new DB.
% Usage 2 concatanates two DBs columnwise. This operation is 
% expensive in the sense that the whole database matrix needs to be 
% enlarged just to add a single new column. The method of allocating
% a matrix, filling it up, and then providing it to the tests_db 
% constructor is the preferred method of creating tests_db objects. 
% This method may be used for measures obtained by operating on raw measures.
%
%   Parameters:
%	obj, b_obj: A tests_db object.
%	test_names: A cell array of test names to be added.
%	test_columns: Data matrix of columns to be added.
%		
%   Returns:
%	obj: The tests_db object that includes the new columns.
%
% See also: allocateRows, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/09/30

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if isa(test_names, 'tests_db')
  to_db = test_names;
  test_names = fieldnames(get(to_db, 'col_idx'));
  test_columns = get(to_db, 'data');
end

if (dbsize(obj, 1) > 0 && size(test_columns, 1) ~= dbsize(obj, 1))
  error(['Number of rows in column (' num2str(size(test_columns, 1)) ') ', ...
	 'does not match rows in DB (' num2str(dbsize(obj, 1)) ').']);
end

if length(test_names) ~= size(test_columns, 2)
  error(['Number of test names (' num2str(length(test_names)) ') ', ...
	 'does not match columns in matrix (' num2str(size(test_columns, 2)) ').']);
end

existing_cols = ismember(test_names, fieldnames(get(obj, 'col_idx')));
if any(existing_cols)
  error('tests_db:col_exists', ...
	['Column(s) ' test_names{existing_cols} ' already exist in DB.']);
end

% Add the column
new_col_id = dbsize(obj, 2) + 1;
obj.data = cat(2, obj.data, test_columns);

% Update the meta-data
new_col_idx = get(obj, 'col_idx');
if isempty(new_col_idx)
  new_col_idx = struct;
end
for test_num = 1:length(test_names)
  new_col_idx.(test_names{test_num}) = new_col_id + test_num - 1;
end

obj = set(obj, 'col_idx', new_col_idx);
