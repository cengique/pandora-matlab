function p_t3ds = invarParams(a_db)

% invarParams - Calculates invariant param dbs for all parameters and returns in a 
%		cell array.
%
% Usage:
% p_t3ds = invarParams(a_db)
%
% Description:
%   Skips the 'ItemIndex' test.
%
%   Parameters:
%	a_db: A tests_db object.
%		
%   Returns:
%	p_t3ds: A cell array of tests_3D_dbs for each param in a_db.
%
% See also: params_tests_profile
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/17

num_params = a_db.num_params;
num_tests = dbsize(a_db, 2) - num_params - 1; %# Except the file indices

p_t3ds = cell(1, num_params);
for param_num=1:num_params
  p_t3ds{param_num} = invarParam(a_db, param_num);
end
