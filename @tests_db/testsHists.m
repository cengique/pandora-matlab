function t_hists = testsHists(a_db, num_bins)

% testsHists - Calculates histograms for all tests and returns them in a cell array.
%
% Usage:
% t_hists = testsHists(a_db, num_bins)
%
% Description:
%
%   Parameters:
%	a_db: A tests_db object.
%	num_bins: Number of histogram bins (Optional, default=100), or
%		  vector of histogram bin centers.
%		
%   Returns:
%	t_hists: An array of histograms for each test in a_db.
%
% See also: params_tests_profile
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/04/27

num_tests = dbsize(a_db(1), 2);

if exist('num_bins')
  bin_param = { num_bins };
else
  bin_param = {};
end

[t_hists(1:num_tests)] = deal(histogram_db);
for test_num=1:num_tests
  params = {a_db, test_num, bin_param{:}};
  t_hists(test_num) = histogram(params{:});
end
