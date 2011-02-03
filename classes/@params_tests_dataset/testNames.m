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
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/10

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('item', 'var')
  item = 1;
end

% Load the first file and
% convert test names to cell array
a_prof = loadItemProfile(dataset, item);
if iscell(a_prof)
  [a_prof a_doc] = deal(a_prof{:});
end

test_names = fieldnames(getResults(a_prof));
test_names = {test_names{:}, 'ItemIndex'};
