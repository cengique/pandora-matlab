function obj = profile(results, id)

% profile - Creates and collects result profiles for data objects.
%
% Usage:
% obj = profile(results, id)
%
%   Parameters:
%	results: A structure containing test results.
%	id: Identification string.
%
% Description:
% This is the base class for all profile classes.
%
% Returns a structure object with the following fields:
%	results, id, props.
%
% General methods of profile objects:
%   profile	- Construct a new profile object.
%   plot	- Graph the profile (N/I).
%   display	- Returns and displays the identification string.
%   getResults  - Returns the results structure.
%
% Additional methods:
%   See methods('profile')
%
% See also: trace_profile, cip_trace_profile
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/14

if nargin == 0 %# Called with no params, creates empty object
  obj.results = struct([]);
  obj.id = '';
  obj = class(obj, 'profile');
elseif isa(results, 'profile') %# copy constructor?
  obj = results;
else
  obj.results = results;
  obj.id = id;

  %# Create the object
  obj = class(obj, 'profile');
end
