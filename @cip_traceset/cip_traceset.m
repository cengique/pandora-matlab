function obj = cip_traceset(ct, cip_mags, dy, props)

% cip_traceset - A traceset with varying cip magnitudes from a single cip_traces object.
%
% Usage:
% obj = cip_traceset(ct, cip_mags, dy, props)
%
% Description:
%   This is a subclass of params_tests_fileset. This traceset can create a 
% mini-database form a single cip_traces object. The list contains cip_mags.
% cip_traceset_dataset should be used to load multiple cip_traceset objects.
%
%   Parameters:
%	ct: A cip_traces object.
%	cip_mags: An array of cip magnitudes to select from the object.
%	dy: y-axis resolution, [V] or [A] (default=1e-3).
%	props: A structure with any optional properties.
%		offsetPotential: Add this to physiology trace as compensation.
%		
%   Returns a structure object with the following fields:
%	params_tests_dataset,
%	ct, props (see above).
%
% General operations on cip_traceset objects:
%   cip_traceset - Construct a new object.
%   display		- Returns and displays the identification string.
%   get			- Gets attributes of this object and parents.
%   subsref		- Allows usage of . operator.
%   loadItemProfile	- Builds a cip_trace_profile for a file in the set.
%   cip_trace		- Load a cip_trace corresponding to fileset entry.
%   cip_trace_profile	- Load a cip_trace_profile corresponding to fileset entry.
%
% Additional methods:
%	See methods('cip_traceset'), and 
%	    methods('params_tests_fileset').
%
% See also: cip_traces, params_tests_fileset, params_tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/11/30

if nargin == 0 %# Called with no params
  obj.ct = cip_traces;
  obj.props = struct([]);
  obj = class(obj, 'cip_traceset', params_tests_dataset);
elseif isa(ct, 'cip_traceset') %# copy constructor?
  obj = ct;
else

  if ~ exist('props')
    props = struct([]);
  end

  if ~ exist('dy')
    dy = 1e-3;
  end

  obj.ct = ct;
  obj.props = props;

  %# Create the object 
  obj = class(obj, 'cip_traceset', ...
	      params_tests_dataset(cip_mags, ct.dt, dy, ct.id, props));

end

