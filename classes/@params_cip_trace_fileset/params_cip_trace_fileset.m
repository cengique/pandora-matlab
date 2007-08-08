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
%	  profile_class_name: Use this profile class (Default: 'cip_trace_profile').
%	  (All other props are passed to cip_trace objects)
%		
%   Returns a structure object with the following fields:
%	params_tests_fileset,
%	pulse_time_start, pulse_time_width.
%
% General operations on params_cip_trace_fileset objects:
%   params_cip_trace_fileset - Construct a new object.
%   display		- Returns and displays the identification string.
%   get			- Gets attributes of this object and parents.
%   subsref		- Allows usage of . operator.
%   loadItemProfile	- Builds a cip_trace_profile for a file in the set.
%   cip_trace		- Load a cip_trace corresponding to fileset entry.
%   cip_trace_profile	- Load a cip_trace_profile corresponding to fileset entry.
%
%    Example:
%	>> fileset = params_cip_trace_fileset('/home/abc/data/*.bin', 1e-4, 1e-3, 20001, 10000, 'sim dataset gpsc0501', struct('trace_time_start', 10001, 'type', 'sim', 'scale_y', 1e3))
%
% Additional methods:
%	See methods('params_cip_trace_fileset'), and 
%	    methods('params_tests_fileset').
%
% See also: params_tests_fileset, params_tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/14

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

if nargin == 0 %# Called with no params
  obj.pulse_time_start = 1;
  obj.pulse_time_width = 0;
  obj = class(obj, 'params_cip_trace_fileset', params_tests_fileset);
elseif isa(file_pattern, 'params_cip_trace_fileset') %# copy constructor?
  obj = file_pattern;
else

  if ~ exist('props')
    props = struct([]);
  end

  obj.pulse_time_start = pulse_time_start;
  obj.pulse_time_width = pulse_time_width;

  %# Create the object 
  obj = class(obj, 'params_cip_trace_fileset', ...
	      params_tests_fileset(file_pattern, dt, dy, id, props));

end

