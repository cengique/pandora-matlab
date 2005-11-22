function a_cip_trace = cip_trace(traceset, trace_index, props)

% cip_trace - Loads a cip_trace object from a raw data file in the traceset.
%
% Usage:
% a_cip_trace = cip_trace(traceset, trace_index, props)
%
% Description:
%
%   Parameters:
%	traceset: A physiol_cip_traceset object.
%	trace_index: Index of file in traceset.
%	props: A structure with any optional properties.
%		
%   Returns:
%	a_cip_trace: A cip_trace object that holds the raw data.
%
% See also: itemResultsRow, params_tests_fileset, paramNames, testNames
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/07/13

if ~ exist('props')
  props = struct;
end

%# First call CIPform and get necessary parameters
[type, on, off, finish, bias, pulse] = CIPform(traceset, trace_index);
pulse_time_start=on;
pulse_time_width= off - on + 1;
ygain = 1 / traceset.vgain;
new_props=struct('type', type, 'on', on, 'off', off, 'finish', finish, 'bias', ...
		 bias, 'pulse', pulse, 'channel', traceset.vchan, 'scale_y', ...
		 ygain, 'traces', num2str(getItem(traceset, trace_index)));

if isfield(props, 'TracesetIndex')
  trace_id = [ 's' num2str(props.TracesetIndex) ',t' num2str(trace_index) ];
else
  trace_id = [ 't' num2str(trace_index) ];
end

traceset_props = get(traceset, 'props');
a_cip_trace = cip_trace(traceset.data_src, get(traceset, 'dt'), ...
			get(traceset, 'dy'), ...
			pulse_time_start, pulse_time_width, ...
			[get(traceset, 'id') '(' trace_id ')'], ...
			mergeStructs(traceset_props, new_props));
