function obj = trace_profile(varargin)

% trace_profile - Creates and collects test results of a trace.
%
% Usage 1:
% obj = trace_profile(a_trace, a_spikes, a_spike_shape, results, id, props)
%
%   Parameters:
%	a_trace: A trace object.
%	a_spikes: A spikes object.
%	a_spike_shape: A spike_shape object for spikes.
%	results: A structure containing test results.
%	id: Identification string.
%	props: A structure any needed properties.
%
% Usage 2:
% obj = trace_profile(data_src, dt, dy, id, props)
%
%    Parameters:
%	data_src: The trace column OR the .MAT filename.
%	dt: Time resolution [s]
%	dy: y-axis resolution [ISI (V, A, etc.)]
%	props: See trace object.
%
% Description:
% The first usage is fully customizable to be used from subclass constructors.
% The second usage generates the spikes and spike_shape objects, and
% collects some generic test results from them. This usage is only provided
% as an example and is not used practically.
%
% Returns a structure object with the following fields:
%	trace, spikes, spike_shape, results, id, props.
%
% General methods of trace_profile objects:
%   trace_profile	- Construct a new trace_profile object.
%   plot		- Graph the trace_profile.
%   display		- Returns and displays the identification string.
%
% Additional methods:
%   See methods('trace_profile')
%
% See also: trace, spikes, spike_shape
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/13

%# TODO: 
%# - How about sim parameter values? [dealt with elsewhere in filesets/dbs]
%# - use getResults to fill up results? [Made alternate constructor signatures]

if nargin < 6
  props = struct([]);
else
  props = varargin{6};
end

if nargin == 0 %# Called with no params, creates empty object
  obj.trace = trace;
  obj.spikes = spikes;
  obj.spike_shape = spike_shape;
  obj.props = struct([]);
  obj = class(obj, 'trace_profile', results_profile);
elseif isa(varargin{1}, 'trace_profile') %# copy constructor?
  obj = varargin{1};
elseif nargin < 4 && isnumeric(varargin{2})
  %# Create all data structures and collect results
  obj.trace = trace(varargin{1:5}, props);
  obj.spikes = spikes(obj.trace);
  obj.spike_shape = spike_shape(obj.trace, obj.spikes);

  %# Calculate all generic tests
  trace_results = getResults(obj.trace);
  rate_results = getResults(obj.spikes, obj.trace);
  shape_results = getResults(obj.spike_shape);

  %# Create the object
  obj = class(obj, 'trace_profile', ...
	      results_profile(mergeStructs(trace_results, rate_results, ...
				   shape_results), ...
		      varargin{5}));
else
  %# Create object with custom data (used from subclasses)
  [ obj.trace, obj.spikes, obj.spike_shape ] = ...
      deal(varargin{1:3});
  obj.props = props;
  %# Create the object
  obj = class(obj, 'trace_profile', results_profile(varargin{4:5}));
end
