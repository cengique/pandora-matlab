function [params_row, tests_row] = fileResultsRow(fileset, file_index)

% fileResultsRow - Processes a raw data file from the fileset and return
%		its parameter and test values.
%
% Usage:
% [params_row, tests_row] = fileResultsRow(fileset, file_index)
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

%# Load a trace_profile object
a_trace_profile = trace_profile(fileset, file_index);

filename = fileset.filenames{file_index};
fullname = fullfile(fileset.path, filename);

names_vals = parseGenesisFilename(fullname);

%# Convert params to row vector
param_row(1:size(names_vals, 1)) = [ names_vals{:, 2} ];

%# Convert results to row vector
resultCell = struct2cell(getResults(a_trace_profile));
tests_row = [ resultCell{:} ];