function item = getItem(dataset, index)

% getItem - Returns the dataset item at given index.
%
% Usage:
% item = getItem(dataset, index)
%
% Description:
%
%   Parameters:
%	dataset: A params_tests_dataset.
%	index: Index of item in dataset.
%		
%   Returns:
%	item: Object, filename, etc.
%
% See also: itemResultsRow, params_tests_dataset, paramNames, testNames
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/03

if iscell(dataset.list)
  item = dataset.list{index};
else
  item = dataset.list(index);
end
