function test_names = testNames(dataset, item)

% testNames - Returns the ordered names of tests for this dataset.
%
% Usage:
% test_names = testNames(dataset, item)
%
% Description:
% Looks at the results of the first file to find the test names.
%
%   Parameters:
%	dataset: A params_tests_dataset.
%		
%   Returns:
%	params_names: Cell array with ordered parameter names.
%	item: (Optional) If given, read names by loading item at this index.
%
% See also: params_tests_dataset, paramNames, testNames
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/10

if ~ exist('item')
  item = 1;
end

%# Load the first file and
%# convert test names to cell array
test_names = fieldnames(getResults(loadItemProfile(dataset, item)));
test_names = {test_names{:}, 'ItemIndex'};
