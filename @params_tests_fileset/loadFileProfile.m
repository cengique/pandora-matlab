function a_profile = loadFileProfile(fileset, file_index)

% loadFileProfile - Loads a profile object from a raw data file in the fileset.
%
% Usage:
% a_profile = loadFileProfile(fileset, file_index)
%
% Description:
%   Subclasses should overload this function to load the specific profile
% object they desire. The profile class should define a getResults method
% which is used in the fileResultsRow method.
%
%   Parameters:
%	fileset: A params_tests_fileset.
%	file_index: Index of file in fileset.
%		
%   Returns:
%	a_profile: A profile object that implements the getResults method.
%
% See also: fileResultsRow, params_tests_fileset, paramNames, testNames
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/14

%# Load a trace_profile object
a_profile = trace_profile(fileset, file_index);