function [pt_hists, p_stats] = paramsTestsHistsStats(p_t3ds, props)

% paramsTestsHistsStats - Calculates histograms and statistics for DB.
%
% Usage:
% [pt_hists, p_stats] = paramsTestsHistsStats(p_t3ds, props)
%
% Description:
%   Calculates histograms and statistics for all combinations of tests 
% and params and returns them in a cell array. Skips the 'ItemIndex' test.
%
%   Parameters:
%	p_t3ds: Array of invariant parameter databases obtained by
%		calling the params_tests_db/invarParams method.
%	props: Optional properties.
%	  statsMethod: method to call to get a stats_db (default='statsMeanSE')
%	  useDiff: If 1, takes the derivative with diff on the 3D DBs (default=0).
%		
%   Returns:
%	pt_hists: An array of 3D histograms for each pair of param 
%		  and test.
%	p_stats: An array of stats_dbs for each param.
%
% See also: invarParams, params_tests_profile
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/17

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

%# TODO: use only p_stats, guess num_params by number of pages

num_params = length(p_t3ds);
num_tests = dbsize(p_t3ds(1), 2) - 2; %# Subtract param and RowIndex columns

if ~ exist('props')
  props = struct;
end

if isfield(props, 'statsMethod')
  stats_func = props.statsMethod;
else
  stats_func = 'statsMeanSE';
end

pt_hists(1:num_tests, 1:num_params) = histogram_db;
p_stats(1:num_params) = stats_db;
for param_num=1:num_params
  %# Sort the param column first
  as_t3d = sortrows(p_t3ds(param_num), 1);
  if isfield(props, 'useDiff') && props.useDiff == 1
    as_t3d = diff(as_t3d);
  end
  %# Then swap dimensions
  ass_t3d = swapRowsPages(as_t3d);
  p_stats(param_num) = feval(stats_func, ass_t3d, ':');
  for test_num=1:num_tests
    pt_hists(test_num, param_num) = histograms(ass_t3d, test_num + 1);
  end
end
