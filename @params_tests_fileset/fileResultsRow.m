function [params_row, tests_row] = fileResultsRow(fileset, file_index)

% fileResultsRow - Processes a raw data file from the fileset and return
%		its parameter and test values.
%
% Usage:
% db_obj = fileResultsRow(obj, props)
%
% Description:
%   This method is intended to be overloaded in customized subclasses
% to process your files with different formats. The contents of this 
% file is provided as an example.
%
%   Parameters:
%	fileset: A params_tests_fileset.
%	file_index: Index of file in fileset.
%		
%   Returns:
%	params_row: Parameter values in the same order of paramNames
%	tests_row: Test values in the same order with testNames
%
% See also: params_tests_fileset, paramNames, testNames
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/10

filename = fileset.filenames{file_index};
fullname = fullfile(fileset.path, filename);

%# Load a trace object
a_trace = trace(fullname, fileset.dt, fileset.dy, ...
		[fileset.id '(' num2str(file_index) ')'], fileset.props);

names_vals = parseGenesisFilename(fullname);

%# Convert params to row vector
param_row(1:size(names_vals, 1)) = [ names_vals{:, 2} ];

%# Convert results to row vector

%# Doesn't exist yet, should be in a trace_profile class:
results = getResults(a_trace); 
resultCell = struct2cell(results);
tests_row = [ resultCell{:} ];