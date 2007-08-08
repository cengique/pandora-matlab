function obj = ...
      cip_trace_allspikes_profile(a_cip_trace, a_spikes, spont_spikes_db, ...
				  pulse_spikes_db, recov_spikes_db, ...
				  results_obj, props)

% cip_trace_allspikes_profile - Creates and collects test results of a cip_trace.
%
% Usage:
% obj = 
%   cip_trace_allspikes_profile(a_cip_trace, a_spikes, a_spont_spike_shape, 
%				results, id, props)
%
%   Parameters:
%	a_cip_trace: A cip_trace object.
%	a_spikes: A spikes object.
%	spont_spikes_db, pulse_spikes_db, recov_spikes_db: 
%		tests_dbs with spontaneous, pulse and recovery period spike info.
%	results_obj: A results_profile object with test results.
%	id: Identification string.
%	props: A structure with any optional properties.
%
% Description:
%   This is a subclass of results_profile. It is made to be used from 
% subclass constructors.
%		
%   Returns a structure object with the following fields:
%	trace, spikes, spont_spikes_db, 
%	pulse_spikes_db, recov_spikes_db, props
%
% General methods of cip_trace_allspikes_profile objects:
%   cip_trace_allspikes_profile	- Construct a new cip_trace_allspikes_profile object.
%   plot		- Graph the cip_trace_allspikes_profile.
%   display		- Returns and displays the identification string.
%   get			- Gets attributes of this object and parents.
%   subsref		- Allows usage of . operator.
%
% Additional methods:
%   See methods('cip_trace_allspikes_profile')
%
% See also: cip_trace, spikes, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/05/04

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

if nargin == 0 %# Called with no params, creates empty object
  obj.trace = cip_trace;
  obj.spikes = spikes;
  obj.spont_spikes_db = tests_db;
  obj.pulse_spikes_db = tests_db;
  obj.recov_spikes_db = tests_db;
  obj.props = struct([]);
  obj = class(obj, 'cip_trace_allspikes_profile', results_profile);
elseif isa(a_cip_trace, 'cip_trace_allspikes_profile') %# copy constructor?
  obj = a_cip_trace;
else 
  %# Create object with custom data (used from subclasses)
  if ~ exist('props')
    props = struct([]);
  end

  obj.trace = a_cip_trace;
  obj.spikes = a_spikes;
  obj.spont_spikes_db = spont_spikes_db;
  obj.pulse_spikes_db = pulse_spikes_db;
  obj.recov_spikes_db = recov_spikes_db;
  obj.props = props;

  %# Create the object
  obj = class(obj, 'cip_trace_allspikes_profile', results_obj);
end


