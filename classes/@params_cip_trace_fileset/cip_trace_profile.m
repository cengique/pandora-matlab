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
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/14

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

props = get(fileset, 'props');

filename = getItem(fileset, file_index);
fullname = fullfile(get(fileset, 'path'), filename);

if ~ isfield(props, 'profile_class_name')
  %# Load a cip_trace_profile object
  a_cip_trace_profile = ...
      cip_trace_profile(fullname, get(fileset, 'dt'), get(fileset, 'dy'), ...
			fileset.pulse_time_start, fileset.pulse_time_width, ...
			[get(fileset, 'id') '(' num2str(file_index) ')'], ...
			get(fileset, 'props'));
else
  %# Otherwise call the designated method that returns a results_profile object
  %# with the cip_trace parameter
  %#disp(['before reading ' filename]);
  a_cip_trace = cip_trace(fullname, get(fileset, 'dt'), get(fileset, 'dy'), ...
			  fileset.pulse_time_start, fileset.pulse_time_width, ...
			  [get(fileset, 'id') '(' num2str(file_index) ')'], ...
			  get(fileset, 'props'));
  %#disp('after reading');
  a_cip_trace_profile = ...
      feval(props.profile_class_name, a_cip_trace);
  %#disp(['after profile' filename]);
end
