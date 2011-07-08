function [params_row, tests_row, a_doc] = itemResultsRow(dataset, index)

% itemResultsRow - Processes a raw data file from the dataset and return
%		its parameter and test values.
%
% Usage:
% [params_row, tests_row] = itemResultsRow(dataset, index)
%
% Description:
%   This method is designed to be reused from subclasses as long as the
% loadItemProfile method is properly overloaded. Adds an Index
% column to the DB to keep track of raw data items after shuffling.
%
%   Parameters:
%	dataset: A params_tests_dataset.
%	index: Index of file in dataset.
%		
%   Returns:
%	params_row: Parameter values in the same order of paramNames
%	tests_row: Test values in the same order with testNames
%
% See also: loadItemProfile, params_tests_dataset, paramNames, testNames
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/10

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

a_doc = [];

% look if custom function defined
prof_func = ...
    getFieldDefault(get(dataset, 'props'), 'loadItemProfileFunc', ...
                                  @loadItemProfile);

% Load any profile object
a_profile = feval(prof_func, dataset, index);

% there can be a doc hidden in there
if iscell(a_profile)
  [a_profile a_doc] = deal(a_profile{:});
end

% Get params row vector
if isa(a_profile, 'params_results_profile')
  params_row = cell2mat(struct2cell(a_profile.params)');
else
  params_row = getItemParams(dataset, index, a_profile);
end

% Convert results to row vector
resultCell = squeeze(struct2cell(getResults(a_profile)))';

% if multiple rows returned
num_rows = size(resultCell, 1);
if num_rows > 1
  params_row = repmat(params_row, num_rows, 1);
  % Add the index as last column
  tests_row = [ cell2mat(resultCell), repmat(index, num_rows, 1) ];
else
  % Add the index as last column
  tests_row = [ resultCell{:}, index ];
end