function obj = ...
      trace_allspikes_profile(a_trace, a_spikes, a_spikes_db, ...
                              results_obj, props)

% trace_allspikes_profile - Collects individual spike-based test results of a trace.
%
% Usage:
% obj = 
%   trace_allspikes_profile(a_trace, a_spikes, a_spikes_db, results_obj, props)
%
%   Parameters:
%	a_trace: A trace object.
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
% General methods of trace_allspikes_profile objects:
%   trace_allspikes_profile	- Construct a new trace_allspikes_profile object.
%   plot		- Graph the trace_allspikes_profile.
%   display		- Returns and displays the identification string.
%   get			- Gets attributes of this object and parents.
%   subsref		- Allows usage of . operator.
%
% Additional methods:
%   See methods('trace_allspikes_profile')
%
% See also: trace, spikes, tests_db
%
% $Id: trace_allspikes_profile.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/05/04

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 % Called with no params, creates empty object
  obj.trace = trace;
  obj.spikes = spikes;
  obj.spikes_db = tests_db;
  obj.props = struct([]);
  obj = class(obj, 'trace_allspikes_profile', results_profile);
elseif isa(a_trace, 'trace_allspikes_profile') % copy constructor?
  obj = a_trace;
else 
  % Create object with custom data (used from subclasses)
  if ~ exist('props', 'var')
    props = struct([]);
  end

  obj.trace = a_trace;
  obj.spikes = a_spikes;
  obj.spikes_db = a_spikes_db;
  obj.props = props;

  % Create the object
  obj = class(obj, 'trace_allspikes_profile', results_obj);
end


