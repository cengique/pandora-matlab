function dataset = addItem(dataset, item)

% addItem - Returns the new dataset with the added item.
%
% Usage:
% dataset = addItem(dataset, item)
%
% Description:
%   Note that, this is NOT the way to create a dataset. It is only intended for 
% small additions to an existing dataset. This method is too slow
% for creating large datasets. The normal method for creating datasets is
% providing the full list of items to the class constructor.
%
%   Parameters:
%	dataset: A params_tests_dataset.
%	item: New item to add in dataset.
%		
%   Returns:
%	dataset: With the added item.
%
% See also: itemResultsRow, params_tests_dataset, paramNames, testNames
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/01/25

if iscell(dataset.list)
  dataset.list = {dataset.list{:}, item};
else
  dataset.list = [dataset.list, item];
end
