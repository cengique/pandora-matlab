function params_row = getParams(dataset, index)

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
%		
%   Returns:
%	params_row: Parameter values in the same order of paramNames
%
% See also: itemResultsRow, params_tests_dataset, paramNames, testNames
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/10

error(['Parameter value acquisition of base class is undefined. '...
       'Please use a subclass of params_tests_dataset.']);

