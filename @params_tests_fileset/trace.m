function a_trace = trace(fileset, file_index)

% trace - Loads a raw trace given a file_index to this fileset.
%
% Usage:
% a_trace = trace(fileset, file_index)
%
% Description:
%
%   Parameters:
%	fileset: A params_tests_fileset.
%	file_index: Index of file in fileset.
%		
%   Returns:
%	a_trace: A trace object.
%
% See also: trace, params_tests_fileset
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/13

filename = getItem(fileset, file_index);
fullname = fullfile(fileset.path, filename);

%# Load a trace object
a_trace = trace(fullname, fileset.dt, fileset.dy, ...
		[fileset.id '(' num2str(file_index) ')'], fileset.props);
