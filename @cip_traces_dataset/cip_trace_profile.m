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
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/14

%# Load a cip_trace_profile object
a_ct = getItem(dataset, index);
a_cip_trace_profile = ...
    cip_trace_profile(a_ct.data(:, dataset.mags), ...
		      get(dataset, 'dt'), get(dataset, 'dy'), ...
		      a_ct.pulse_time_start, a_ct.pulse_time_width, ...
		      [get(dataset, 'id') '(' num2str(index) ')'], ...
		      get(dataset, 'props'));
