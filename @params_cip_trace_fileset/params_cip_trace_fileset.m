function obj = ...
      params_cip_trace_fileset(file_pattern, dt, dy, ...
			       pulse_time_start, pulse_time_width, id, props)

% params_cip_trace_fileset - 
%	Description of a raw dataset consisting of cip_trace files varying 
%	with parameter values.
%
% Usage:
% obj = params_cip_trace_fileset(file_pattern, dt, dy, 
%				 pulse_time_start, pulse_time_width, id, props)
%
% Description:
%   This is a subclass of params_tests_fileset.
%
%   Parameters:
%	file_pattern: File pattern mathing all files to be loaded.
%	dt: Time resolution [s]
%	dy: y-axis resolution [ISI (V, A, etc.)]
%	pulse_time_start, pulse_time_width:
%		Start and width of the pulse [dt]
%	id: An identification string
%	props: A structure with any optional properties.
%		channel: Channel to read from in data files (default = 1).
%		trace_start: Starting of trace in file (default = 1).
%		type: type of file (default = '')
%		
%   Returns a structure object with the following fields:
%	params_tests_fileset,
%	pulse_time_start, pulse_time_width, props (see above).
%
% General operations on params_cip_trace_fileset objects:
%   params_cip_trace_fileset - Construct a new object.
%   display		- Returns and displays the identification string.
%   get			- Gets attributes of this object and parents.
%   subsref		- Allows usage of . operator.
%   loadFileProfile	- Builds a cip_trace_profile for a file in the set.
%   cip_trace		- Load a cip_trace corresponding to fileset entry.
%   cip_trace_profile	- Load a cip_trace_profile corresponding to fileset entry.
%
% Additional methods:
%	See methods('params_cip_trace_fileset'), and 
%	    methods('params_tests_fileset').
%
% See also: params_tests_fileset, params_tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/14

if nargin == 0 %# Called with no params
  obj.pulse_time_start = 1;
  obj.pulse_time_width = 0;
  obj.props = struct([]);
  obj = class(obj, 'params_cip_trace_fileset', params_tests_fileset);
elseif isa(file_pattern, 'params_cip_trace_fileset') %# copy constructor?
  obj = file_pattern;
else

  if ~ exist('props')
    props = struct([]);
  end

  obj.pulse_time_start = pulse_time_start;
  obj.pulse_time_width = pulse_time_width;
  obj.props = props;

  %# Create the object 
  obj = class(obj, 'params_cip_trace_fileset', ...
	      params_tests_fileset(file_pattern, dt, dy, id, props));

end

