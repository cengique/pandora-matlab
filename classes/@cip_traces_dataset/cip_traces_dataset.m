function obj = cip_traces_dataset(ts, cipmag, id, props)

% cip_traces_dataset - Dataset of cip_traces objects, each with varying cip magnitudes.
%
% Usage:
% obj = cip_traces_dataset(ts, cipmag, id, props)
%
% Description:
%   This is a subclass of params_tests_fileset.
%
%   Parameters:
%	ts: A cell array of cip_traces objects.
%	cipmag: A single cip magnitude to trace take from objects.
%	id: An identification string for the whole dataset.
%	props: A structure with any optional properties passed to cip_trace_profile.
%		
%   Returns a structure object with the following fields:
%	params_tests_dataset,
%	cipmag, props (see above).
%
% General operations on cip_traces_dataset objects:
%   cip_traces_dataset - Construct a new object.
%   display		- Returns and displays the identification string.
%   get			- Gets attributes of this object and parents.
%   subsref		- Allows usage of . operator.
%   loadItemProfile	- Builds a cip_trace_profile for a file in the set.
%   cip_trace		- Load a cip_trace corresponding to fileset entry.
%   cip_trace_profile	- Load a cip_trace_profile corresponding to fileset entry.
%
% Additional methods:
%	See methods('cip_traces_dataset'), and 
%	    methods('params_tests_fileset').
%
% See also: cip_traces, params_tests_fileset, params_tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/11/30

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

%# TODO: repeat the list for each cipmag. Then change cip_trace_profile
%# to return one with a different cipmag according to index in list.

if nargin == 0 %# Called with no params
  obj.cipmag = [];
  obj.props = struct([]);
  obj = class(obj, 'cip_traces_dataset', params_tests_dataset);
elseif isa(ts, 'cip_traces_dataset') %# copy constructor?
  obj = ts;
else

  if ~ exist('props')
    props = struct([]);
  end

  obj.cipmag = cipmag;
  obj.props = props;

  %# Get the dt from first object
  if iscell(ts)
    dt = ts{1}.dt;
  else
    dt = ts(1).dt;
  end

  %# Create the object 
  obj = class(obj, 'cip_traces_dataset', ...
	      params_tests_dataset(ts, dt, 1e-3, id, props));

end

