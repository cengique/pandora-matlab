function test_names = testNames(dataset)

% testNames - Returns the ordered names of tests for this dataset.
%
% Usage:
% test_names = testNames(dataset)
%
% Description:
% Looks at the results of the first file to find the test names.
%
%   Parameters:
%	dataset: A params_tests_dataset.
%		
%   Returns:
%	params_names: Cell array with ordered parameter names.
%
% See also: params_tests_dataset, paramNames, testNames
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/10

%# Load the first file and
%# convert test names to cell array
test_names = fieldnames(getResults(loadItemProfile(dataset, 1)));
test_names = {test_names{:}, 'ItemIndex'};
