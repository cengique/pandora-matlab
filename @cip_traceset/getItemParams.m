function params_row = getParams(dataset, index, a_profile)

% getParams - Get the parameter values of a dataset item.
%
% Usage:
% params_row = getParams(dataset, index)
%
% Description:
%
%   Parameters:
%	dataset: A params_tests_dataset.
%	index: Index of item in dataset.
%	a_profile: A profile object for the item (optional).
%		
%   Returns:
%	params_row: Parameter values in the same order of paramNames
%
% See also: itemResultsRow, params_tests_dataset, paramNames, testNames
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/06

%# Take the cip_mage from list
params_row = [ getItem(dataset, index) ];