function test_names = testNames(fileset)

% testNames - Returns the ordered names of tests for this fileset.
%
% Usage:
% test_names = testNames(fileset)
%
% Description:
% Looks at the results of the first file to find the test names.
%
%   Parameters:
%	fileset: A params_tests_fileset.
%		
%   Returns:
%	params_names: Cell array with ordered parameter names.
%
% See also: params_tests_fileset, paramNames, testNames
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/10

filename = fileset.filenames{1};
fullname = fullfile(fileset.path, filename);

%# Load any profile object
a_profile = loadFileProfile(fileset, file_index);

%# Convert test names to cell array
test_names = fieldnames(getResults(a_profile));