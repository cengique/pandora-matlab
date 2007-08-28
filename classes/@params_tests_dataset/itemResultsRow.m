function [params_row, tests_row] = itemResultsRow(dataset, index)

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

%# Load any profile object
a_profile = loadItemProfile(dataset, index);

%# Get params row vector
params_row = getItemParams(dataset, index, a_profile);

%# Convert results to row vector
resultCell = struct2cell(getResults(a_profile));

%# Add the index as last column
tests_row = [ resultCell{:}, index ];