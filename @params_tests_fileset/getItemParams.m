function params_row = getItemParams(dataset, index)

% getItemParams - Get the parameter values of a dataset item.
%
% Usage:
% params_row = getItemParams(dataset, index)
%
% Description:
%
%   Parameters:
%	dataset: A params_tests_dataset.
%	index: Index of item in dataset.
%		
%   Returns:
%	params_row: Parameter values in the same order of paramNames
%
% See also: itemResultsRow, params_tests_dataset, paramNames, testNames
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/03

filename = getItem(dataset, index);
fullname = fullfile(dataset.path, filename);

names_vals = parseGenesisFilename(fullname);

%# Convert params to row vector
params_row(1:size(names_vals, 1)) = [ names_vals{:, 2} ];
