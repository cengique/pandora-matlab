function a_cip_trace = cip_trace(fileset, file_index)

% cip_trace - Loads a raw cip_trace given a file_index to this fileset.
%
% Usage:
% a_cip_trace = cip_trace(fileset, file_index)
%
% Description:
%
%   Parameters:
%	fileset: A params_tests_fileset.
%	file_index: Index of file in fileset.
%		
%   Returns:
%	a_cip_trace: A cip_trace object.
%
% See also: cip_trace, params_tests_fileset
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/13

filename = getItem(fileset, file_index);
fullname = fullfile(get(fileset, 'path'), filename);

%# Load a cip_trace object
a_cip_trace = ...
    cip_trace(fullname, get(fileset, 'dt'), get(fileset, 'dy'), ...
	      fileset.pulse_time_start, fileset.pulse_time_width, ...
	      [get(fileset, 'id') '(' num2str(file_index) ')'], ...
	      get(fileset, 'props'));

