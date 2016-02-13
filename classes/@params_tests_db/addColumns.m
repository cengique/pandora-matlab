function obj = addColumns(obj, test_names, test_columns)

% addColumns - Inserts new columns to tests_db.
%
% Usage 1:
% obj = addColumns(obj, test_names, test_columns)
%
% Usage 2:
% obj = addColumns(obj, b_obj)
%
% Parameters:
%   obj, b_obj: A tests_db object.
%   test_names: A single string or a cell array of test names to be added.
%   test_columns: Data matrix of columns to be added.
%		
% Returns:
%   obj: The tests_db object that includes the new columns.
%
% Description:
%   Delegates to tests_db/addColumns, but maintains parameter
% columns for the 2nd usage.
%
% See also: tests_db/addColumns, allocateRows, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2015/05/18

% Copyright (c) 2015 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin > 2
  obj.tests_db = addColumns(obj.tests_db, test_names, test_columns);
else
  add_db = test_names;
  if isa(test_names, 'params_tests_db')
    % add params and tests separately and then concat
    a_params_db = addColumns(obj.tests_db(:, 1:obj.num_params), ...
                             add_db.tests_db(:, 1:add_db.num_params));
    a_tests_db = addColumns(obj.tests_db(:, (obj.num_params + 1):end), ...
                            add_db.tests_db(:, (add_db.num_params + 1):end));
    obj.tests_db = addColumns(a_params_db, a_tests_db);
    obj.num_params = obj.num_params + add_db.num_params;
  else
    obj.tests_db = addColumns(obj.tests_db, add_db);
  end
end
