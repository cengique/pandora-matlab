function p_hists = paramsHists(a_db)

% paramsHists - Calculates histograms for all parameters and returns in a 
%		cell array.
%
% Usage:
% p_hists = paramsHists(a_db)
%
% Description:
%   Skips the 'ItemIndex' test. Useful for looking at subset databases and
% find out what parameter values are used most.
%
%   Parameters:
%	a_db: A tests_db object.
%		
%   Returns:
%	p_hists: A cell array of histograms for each parameter in a_db.
%
% See also: params_tests_profile
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/20

num_params = a_db.num_params;
num_tests = dbsize(a_db, 2) - num_params - 1; %# Except the file indices

p_hists = cell(1, num_params);
for param_num=1:num_params
  %# First find all unique values of the parameter
  param_col = sortrows(get(onlyRowsTests(a_db, ':', param_num), 'data'));
  param_vals = sortedUniqueValues(param_col)
  %# Give the param_vals as bin centers
  p_hists{param_num} = histogram(a_db, param_num, param_vals');
end
