function p_coefs = paramsCoefs(a_db, p_t3ds)

% paramsCoefs - Calculates a corrcoefs_db for each param and collects them in a cell array.
%
% Usage:
% p_coefs = paramsCoefs(a_db, p_t3ds)
%
% Description:
%   Skips the 'ItemIndex' test.
%
%   Parameters:
%	a_db: A tests_db object.
%	p_t3ds: Cell array of invariant parameter databases.
%		
%   Returns:
%	p_coefs: A cell array of corrcoefs_dbs for each param in a_db.
%
% See also: params_tests_profile
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/17

num_params = a_db.num_params;
num_tests = dbsize(a_db, 2) - num_params - 1; %# Except the file indices

p_coefs = cell(1, num_params);
for param_num=1:num_params
  a_t3d = p_t3ds(param_num);
  all_test_cols(2:dbsize(a_t3d, 2)) = true(1);
  all_test_cols(tests2cols(a_t3d, {'RowIndex', 'ItemIndex'})) = false(1,2);
  p_coefs{param_num} = corrCoefs(a_t3d, 1, find(all_test_cols));
end
