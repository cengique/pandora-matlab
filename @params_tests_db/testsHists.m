function t_hists = testsHists(a_db)

% testsHists - Calculates histograms for all tests and returns in a 
%		cell array.
%
% Usage:
% t_hists = testsHists(a_db)
%
% Description:
%   Skips the 'ItemIndex' test.
%
%   Parameters:
%	a_db: A tests_db object.
%		
%   Returns:
%	t_hists: An array of histograms for each test in a_db.
%
% See also: params_tests_profile
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/17

num_params = a_db.num_params;
num_tests = dbsize(a_db, 2) - num_params - 1; %# Except the file indices

[t_hists(1:num_tests)] = deal(histogram_db);
for test_num=1:num_tests
  t_hists(test_num) = histogram(a_db, num_params + test_num);
end
