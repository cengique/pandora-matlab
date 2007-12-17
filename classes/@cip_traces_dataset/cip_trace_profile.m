function a_cip_trace_profile = cip_trace_profile(dataset, index)

% cip_trace_profile - Loads a raw cip_trace_profile given a index 
%		      to this dataset.
%
% Usage:
% a_cip_trace_profile = cip_trace_profile(dataset, index)
%
% Description:
%
%   Parameters:
%	dataset: A params_tests_dataset.
%	index: Index of file in dataset.
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

% Load a cip_trace_profile object
a_ct = getItem(dataset, index);

% Find cip magnitude index
magidx = find(a_ct.pulse_mags_pA == dataset.cipmag);

if length(magidx) == 0 
  error(['CIP magnitude ' num2str(dataset.cipmag) ' cannot be found in ' a_ct '.']);
end

% Create profile by analyzing raw data
a_cip_trace_profile = ...
    cip_trace_profile(a_ct.data(:, magidx(1)), ...
		      get(dataset, 'dt'), get(dataset, 'dy'), ...
		      a_ct.pulse_time_start, a_ct.pulse_time_width, ...
		      [get(dataset, 'id') '(' num2str(index) ')'], ...
		      get(dataset, 'props'));
