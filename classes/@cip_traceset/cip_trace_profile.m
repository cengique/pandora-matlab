function a_cip_trace_profile = cip_trace_profile(traceset, index)

% cip_trace_profile - Loads a raw cip_trace_profile given an index in this traceset.
%
% Usage:
% a_cip_trace_profile = cip_trace_profile(traceset, index)
%
% Description:
%
%   Parameters:
%	traceset: A cip_traceset.
%	index: Index of item in traceset.
%		
%   Returns:
%	a_cip_trace_profile: A cip_trace_profile object.
%
% See also: cip_trace_profile, params_tests_dataset
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/14

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Get the cip magnitude for the item
cip_mag = getItem(traceset, index);

% Find the cip magnitude index in the cip_traces object
mag_idx = find(traceset.ct.pulse_mags_pA == cip_mag);

if length(mag_idx) == 0 
  error(['CIP magnitude ' num2str(cip_mag) ' cannot be found in ' traceset.ct '.']);
end

data = traceset.ct.data(:, mag_idx(1));
if isfield(traceset.props, 'offsetPotential')
  data = data + traceset.props.offsetPotential;
end

% Create profile by analyzing raw data
a_cip_trace_profile = ...
    cip_trace_profile(data, ...
		      get(traceset, 'dt'), get(traceset, 'dy'), ...
		      traceset.ct.pulse_time_start, traceset.ct.pulse_time_width, ...
		      [get(traceset, 'id') '(' num2str(index) ')'], ...
		      get(traceset, 'props'));
