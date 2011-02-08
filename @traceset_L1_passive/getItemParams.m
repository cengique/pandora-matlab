function params_row = getItemParams(dataset, index, a_profile)

% getItemParams - Get the parameter values of a dataset item.
%
% Usage:
% params_row = getItemParams(dataset, index, a_profile)
%
% Description:
%   This method can retrieve the item parameters by using either the 
% dataset and the index to find the item or simply by using
% the item profile, a_profile.
%
%   Parameters:
%	dataset: A params_tests_dataset.
%	index: Index of item in dataset.
% 	a_profile: An item profile.
%		
%   Returns:
%	params_row: Parameter values in the same order of paramNames
%
% See also: itemResultsRow, params_tests_dataset, paramNames, testNames
%
% $Id: getItemParams.m 818 2007-08-28 20:28:51Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/10

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% assuming the item is the trace number to be put into the file template
trace_num = getItem(dataset, index)

if isnumeric(trace_num)
  params_row = trace_num;
else
  params_row = index;
end
