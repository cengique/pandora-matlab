function [pt_hists, p_stats] = paramsTestsHistsStats(a_db, p_t3ds)

% paramsTestsHistsStats - Calculates histograms and statistics for all 
%			  combinations of tests and params and returns 
%			  them in a cell array.
%
% Usage:
% [pt_hists, p_stats] = paramsTestsHistsStats(a_db, p_t3ds)
%
% Description:
%   Skips the 'FileIndex' test.
%
%   Parameters:
%	a_db: A tests_db object.
%	p_t3ds: Cell array of invariant parameter databases.
%		
%   Returns:
%	pt_hists: A cell array of 3D histograms for each pair of param 
%		  and test.
%	p_stats: A cell array of stats_dbs for each param.
%
% See also: params_tests_profile
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/17

num_params = a_db.num_params;
num_tests = size(a_db, 2) - num_params - 1; %# Except the file indices

pt_hists = cell(num_tests, num_params);
p_stats = cell(1, num_params);
for param_num=1:num_params
  %# Sort the param column first
  as_t3d = sortrows(p_t3ds{param_num}, 1);
  %# Then swap dimensions
  ass_t3d = swapRowsPages(as_t3d);
  p_stats{param_num} = statsMeanStd(ass_t3d, ':');
  for test_num=1:num_tests
    pt_hists{test_num, param_num} = histograms(ass_t3d, test_num + 1);
  end
end
