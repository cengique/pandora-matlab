function a_profile = cip_trace_profile(traceset, trace_index)

% cip_trace_profile - Loads a cip_trace_profile object from a raw data file in the traceset.
%
% Usage:
% a_profile = cip_trace_profile(traceset, trace_index)
%
% Description:
%
%   Parameters:
%	traceset: A physiol_cip_traceset object.
%	trace_index: Index of file in traceset.
%		
%   Returns:
%	a_profile: A profile object that implements the getResults method.
%
% See also: itemResultsRow, params_tests_fileset, paramNames, testNames
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu> and Thomas Sangrey, 2005/01/18

%# First call CIPform and get necessary parameters
[type, on, off, finish, bias, pulse] = CIPform(traceset, trace_index);
pulse_time_start=on;
pulse_time_width= off - on + 1;
ygain = 1 / traceset.vgain;
props=struct('type', type, 'on', on, 'off', off, 'finish', finish, 'bias', ...
	     bias, 'pulse', pulse, 'channel', traceset.vchan, 'scale_y', ...
		 ygain, 'traces', num2str(getItem(traceset, trace_index)));

%# Load a trace_profile object
a_profile = cip_trace_profile(traceset.data_src, get(traceset, 'dt'), ...
			      get(traceset, 'dy'), ...
			      pulse_time_start, pulse_time_width, ...
			      get(traceset, 'id'), ...
			      mergeStructs(get(traceset, 'props'), props));
