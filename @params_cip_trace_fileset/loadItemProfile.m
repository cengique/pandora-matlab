function a_profile = loadItemProfile(fileset, file_index)

% loadItemProfile - Loads a cip_trace_profile object from a raw data file in the fileset.
%
% Usage:
% [params_row, tests_row] = loadItemProfile(fileset, file_index)
%
% Description:
%
%   Parameters:
%	fileset: A params_tests_fileset.
%	file_index: Index of file in fileset.
%		
%   Returns:
%	a_profile: A profile object that implements the getResults method.
%
% See also: itemResultsRow, params_tests_fileset, paramNames, testNames
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/14

%# Load a trace_profile object
a_profile = cip_trace_profile(fileset, file_index);