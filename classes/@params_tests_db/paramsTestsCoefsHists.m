function pt_coefs_hists = paramsTestsCoefsHists(a_db, p_coefs)

% paramsTestsCoefsHists - Calculates histograms for all pairs of params 
%		  and tests coefficients and returns in a cell array.
%
% Usage:
% pt_coefs_hists = paramsTestsCoefsHists(a_db, p_coefs)
%
% Description:
%   Skips the 'ItemIndex' test.
%
%   Parameters:
%	a_db: A tests_db object.
%	p_coefs: Cell array of tests coefficients for each parameter.
%		
%   Returns:
%	pt_coefs_hists: A cell array of corrcoefs_dbs for each param in a_db.
%
% See also: params_tests_profile
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/17

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

num_params = a_db.num_params;
num_tests = dbsize(a_db, 2) - num_params - 1; %# Except the file indices

pt_coefs_hists = cell(num_tests, num_params);
for param_num=1:num_params
  for test_num=1:num_tests
    pt_coefs_hists{test_num, param_num} = ...
	histogram(p_coefs{param_num}, test_num);
  end
end
