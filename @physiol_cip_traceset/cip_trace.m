function a_cip_trace = cip_trace(traceset, trace_index)

% cip_trace - Loads a cip_trace object from a raw data file in the traceset.
%
% Usage:
% a_cip_trace = cip_trace(traceset, trace_index)
%
% Description:
%
%   Parameters:
%	traceset: A physiol_cip_traceset object.
%	trace_index: Index of file in traceset.
%		
%   Returns:
%	a_cip_trace: A cip_trace object that holds the raw data.
%
% See also: itemResultsRow, params_tests_fileset, paramNames, testNames
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/07/13

%# First call CIPform and get necessary parameters
[type, on, off, finish, bias, pulse] = CIPform(traceset, trace_index);
pulse_time_start=on;
pulse_time_width= off - on + 1;
ygain = 1 / traceset.vgain;
props=struct('type', type, 'on', on, 'off', off, 'finish', finish, 'bias', ...
	     bias, 'pulse', pulse, 'channel', traceset.vchan, 'scale_y', ...
		 ygain, 'traces', num2str(getItem(traceset, trace_index)));

traceset_props = get(traceset, 'props');
a_cip_trace = cip_trace(traceset.data_src, get(traceset, 'dt'), ...
			get(traceset, 'dy'), ...
			pulse_time_start, pulse_time_width, ...
			[get(traceset, 'id') '(' num2str(trace_index) ')'], ...
			mergeStructs(traceset_props, props));
