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
%
% Author: Cengiz Gunay <cgunay@emory.edu> and Thomas Sangrey, 2005/01/18

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

traceset_props = get(traceset, 'props');

if ~ isfield(traceset_props, 'profile_class_name')
  %# First call CIPform and get necessary parameters
  [type, on, off, finish, bias, pulse] = CIPform(traceset, trace_index);
  pulse_time_start=on;
  pulse_time_width= off - on + 1;
  ygain = 1 / traceset.vgain;
  props=struct('type', type, 'on', on, 'off', off, 'finish', finish, ...
	       'bias', bias, 'pulse', pulse, 'channel', traceset.vchan, ...
	       'scale_y', ygain, ...
	       'traces', num2str(getItem(traceset, trace_index)));

  trace_props = traceset_props.Trials{trace_index};
%   dt = 1/trace_props.AcquisitionData{traceset.vchan}.SamplingRate;
%   dy = 

  %# Load a trace_profile object
  a_profile = cip_trace_profile(traceset.data_src, get(traceset, 'dt'), ...
				get(traceset, 'dy'), ...
				pulse_time_start, pulse_time_width, ...
				[get(traceset, 'id') '(' num2str(trace_index) ')'], ...
				mergeStructs(trace_props, props));
else
  %# Otherwise call the designated method that returns a results_profile object
  %# with the cip_trace parameter
  a_cip_trace = cip_trace(traceset, trace_index);
  a_profile = ...
      feval(traceset_props.profile_class_name, a_cip_trace);
end
