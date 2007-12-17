function cross_db = crossProd(a_db, b_db)

% crossProd - Create a DB by taking the cross product of two database row sets.
%
% Usage:
% cross_db = crossProd(a_db, b_db)
%
% Description:
%   Overloaded function to maintain correct number of parameters after
% cross product operation. See original in tests_db/crossProd.
%
%   Parameters:
%	a_db, b_db: A tests_db object.
%		
%   Returns:
%	cross_db: The tests_db object with all combinations of rows.
%
% See also: tests_db/crossProd
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/10/11

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

a_num_params = get(a_db, 'num_params');
b_num_params = get(b_db, 'num_params');

% Find cross product only with params
a_params_db = onlyRowsTests(a_db, ':', 1:a_num_params);
b_params_db = onlyRowsTests(b_db, ':', 1:b_num_params);
both_params_db = crossProd(a_params_db.tests_db, b_params_db.tests_db);

% Find cross product only with tests
a_tests_db = onlyRowsTests(a_db, ':', (a_num_params + 1):dbsize(a_db, 2));
b_tests_db = onlyRowsTests(b_db, ':', (b_num_params + 1):dbsize(b_db, 2));
both_tests_db = crossProd(a_tests_db.tests_db, b_tests_db.tests_db);

% Combine both
a_db.tests_db = both_params_db;
a_db.num_params = a_num_params + b_num_params;
cross_db = addColumns(a_db, both_tests_db);
