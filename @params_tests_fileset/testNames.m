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

%# Load a trace object
a_trace = trace(fullname, fileset.dt, fileset.dy, ...
		[fileset.id '(' num2str(file_index) ')'], fileset.props);

results = getResults(a_trace); 

%# Convert test names to cell array
test_names = fieldnames(results);