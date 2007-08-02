function obj = results_profile(results, id, props)

% results_profile - Creates and collects result profiles for data objects.
%
% Usage:
% obj = results_profile(results, id, props)
%
%   Parameters:
%	results: A structure containing test results.
%	id: Identification string.
%	props: A structure with any optional properties.
%
% Description:
% This is the base class for all profile classes.
%
% Returns a structure object with the following fields:
%	results, id, props.
%
% General methods of results_profile objects:
%   results_profile	- Construct a new results_profile object.
%   getResults  - Returns the results structure.
%   display	- Returns and displays the identification string.
%   get		- Gets attributes of this object and parents.
%   subsref	- Allows usage of . operator.
%
% Additional methods:
%   See methods('results_profile')
%
% See also: trace_profile, cip_trace_profile
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/14

if nargin == 0 %# Called with no params, creates empty object
  obj.results = struct([]);
  obj.id = '';
  obj.props = struct([]);
  obj = class(obj, 'results_profile');
elseif isa(results, 'results_profile') %# copy constructor?
  obj = results;
else
  if ~ exist('props')
    props = struct([]);
  end

  obj.results = results;
  obj.id = id;
  obj.props = props;

  %# Create the object
  obj = class(obj, 'results_profile');
end
