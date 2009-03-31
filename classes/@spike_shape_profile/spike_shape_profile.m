function a_ss_profile = spike_shape_profile(results, a_spike_shape, props)

% spike_shape_profile - Holds the results profile from a spike_shape object.
%
% Usage:
% a_ss_profile = spike_shape_profile(results, a_spike_shape, props)
%
%   Parameters:
%	results: A structure containing test results.
%	a_spike_shape: A spike_shape object.
%	props: A structure with any optional properties.
%
% Description:
%		
%   Returns a structure object with the following fields:
%	results_profile: Contains results of tests.
%	spike_shape: The spike_shape object from which results were obtained.
%	props.
%
% General methods of spike_shape_profile objects:
%   spike_shape_profile- Construct a new spike_shape_profile object.
%   plot		- Graph the spike_shape_profile.
%   display		- Returns and displays the identification string.
%   get			- Gets attributes of this object and parents.
%   subsref		- Allows usage of . operator.
%
% Additional methods:
%   See methods('spike_shape_profile')
%
% See also: results_profile
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/08/17

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 % Called with no params, creates empty object
  a_ss_profile.spike_shape = spike_shape;
  a_ss_profile = class(a_ss_profile, 'spike_shape_profile', results_profile);
elseif isa(results, 'spike_shape_profile') % copy constructor?
  a_ss_profile = results;
else 
  if ~ exist('props', 'var')
    props = struct([]);
  end

  a_ss_profile.spike_shape = a_spike_shape;

  % Create the object
  a_ss_profile = class(a_ss_profile, 'spike_shape_profile', ...
		       results_profile(results, get(a_spike_shape, 'id'), props));
end
