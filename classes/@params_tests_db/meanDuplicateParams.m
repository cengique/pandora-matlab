function a_params_tests_db = meanDuplicateParams(a_params_tests_db, props)

% meanDuplicateParams - Takes the mean of all measures for rows that have the same parameter columns.
%
% Usage:
% a_params_tests_db = meanDuplicateParams(db, props)
%
% Description:
%   Calls tests_db/meanDuplicateRows with params as main_cols and tests
% as rest_cols.
%
%   Parameters:
%	db: A params_tests_db object.
%	props: Structure with optional parameters.
%		
%   Returns:
%	a_params_tests_db: The db object of with the means on page 1 
%		    and standard deviations on page 2.
%
% See also: tests_db/meanDuplicateRows, tests_db/mean, tests_db/std, sortedUniqueValues
%
% $Id: meanDuplicateParams.m 896 2007-12-17 18:48:55Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2007/12/20

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

num_params = a_params_tests_db.num_params;
% Insert new values as parameters
a_params_tests_db = ...
    set(meanDuplicateRows(a_params_tests_db, 1:num_params, ...
                          (num_params + 1):dbsize(a_params_tests_db, 2)), ...
        'num_params', num_params + 2);
