function a_cip_trace_profile = cip_trace_profile(fileset, file_index)

% cip_trace_profile - Loads a raw cip_trace_profile given a file_index 
%		      to this fileset.
%
% Usage:
% a_cip_trace_profile = cip_trace_profile(fileset, file_index)
%
% Description:
%
%   Parameters:
%	fileset: A params_tests_fileset.
%	file_index: Index of file in fileset.
%		
%   Returns:
%	a_cip_trace_profile: A cip_trace_profile object.
%
% See also: cip_trace_profile, params_tests_fileset
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/14

filename = fileset.filenames{file_index};
fullname = fullfile(fileset.path, filename);

%# Load a cip_trace_profile object
a_cip_trace_profile = ...
    cip_trace_profile(fullname, fileset.dt, fileset.dy, ...
		      fileset.pulse_time_start, fileset.pulse_time_width, 
		      [fileset.id '(' num2str(file_index) ')'], ...
		      fileset.props);
