function obj = ...
      cip_trace_profile(a_cip_trace, a_spikes, a_spont_spike_shape, ...
			results, id, props)

% cip_trace_profile - Creates and collects test results of a cip_trace.
%
% Usage:
% obj = 
%   cip_trace_profile(a_cip_trace, a_spikes, a_spont_spike_shape, 
%			results, id, props)
%
% Description:
%		
% Holds test results from a cip_trace, and other related objects.
% This class should be subclassed for special extraction of test results
% for different experiments. Results will be empty for this object.
%
%   Parameters:
%	a_cip_trace: A cip_trace object.
%	a_spikes: A spikes object.
%	a_spont_spike_shape: A spike_shape object for spont spikes.
%	results: A structure containing test results.
%	id: Identification string.
%	props: A structure any needed properties.
%
%   Returns a structure object with the following fields:
%	trace, spikes, spont_spike_shape, results, id, props.
%
% General methods of cip_trace_profile objects:
%   cip_trace_profile	- Construct a new cip_trace_profile object.
%   plot		- Graph the cip_trace_profile.
%   display		- Returns and displays the identification string.
%
% Additional methods:
%   See methods('cip_trace_profile')
%
% See also: cip_trace, spikes, spike_shape
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/25

%# TODO: 
%# - How about sim parameter values?
%# - use getResults to fill up results? [May be incompatible with subclasses]

if nargin == 0 %# Called with no params, creates empty object
  obj.trace = trace;
  obj.spikes = spikes;
  obj.spont_spike_shape = spike_shape;
  obj.results = struct([]);
  obj.id = '';
  obj.props = struct([]);
  obj = class(obj, 'cip_trace_profile');
elseif isa(a_cip_trace, 'cip_trace_profile') %# copy constructor?
  obj = datasrc;
else
  if ~ exist('props')
    props = struct([]);
  end
  obj.props = props;
  obj.trace = a_cip_trace; 
  obj.spikes = a_spikes;
  obj.spont_spike_shape = a_spont_spike_shape;
  obj.results = results;
  obj.id = id;

  %# Create the object
  obj = class(obj, 'cip_trace_profile');
end
