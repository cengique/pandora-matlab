function a_trace_profile = trace_profile(fileset, file_index)

% trace_profile - Loads a raw trace_profile given a file_index to this fileset.
%
% Usage:
% a_trace_profile = trace_profile(fileset, file_index)
%
% Description:
%
%   Parameters:
%	fileset: A params_tests_fileset.
%	file_index: Index of file in fileset.
%		
%   Returns:
%	a_trace_profile: A trace_profile object.
%
% See also: trace_profile, params_tests_fileset
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/13

filename = getItem(fileset, file_index);
fullname = fullfile(fileset.path, filename);

%# Load a trace_profile object
a_trace_profile = trace_profile(fullname, fileset.dt, fileset.dy, ...
				[fileset.id '(' num2str(file_index) ')'], ...
				fileset.props);
