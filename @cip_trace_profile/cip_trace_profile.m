function obj = ...
      cip_trace_profile(varargin)

% cip_trace_profile - Creates and collects test results of a cip_trace.
%
% Usage 1:
% obj = 
%   cip_trace_profile(a_cip_trace, a_spikes, a_spont_spike_shape, 
%		      results, id, props)
%   Parameters:
%	a_cip_trace: A cip_trace object.
%	a_spikes: A spikes object.
%	a_spont_spike_shape: A spike_shape object for spont spikes.
%	a_pulse_spike_shape: A spike_shape object for pulse spikes.
%	results: A structure containing test results.
%	id: Identification string.
%	props: A structure with any optional properties.
%
% Usage 2:
% obj = cip_trace_profile(data_src, dt, dy, pulse_time_start, pulse_time_width, 
%	                  id, props)
%
%    Parameters:
%	data_src: The trace column OR the filename.
%	dt: Time resolution [s]
%	dy: y-axis resolution [ISI (V, A, etc.)]
%	pulse_time_start, pulse_time_width:
%		Start and width of the pulse [dt]
%	id: Identification string.
%	props: See trace object.
%
% Description:
% The first usage is fully customizable to be used from subclass constructors.
% The second usage generates the spikes and spont_spike_shape objects, and
% collects some generic test results from them. 
%		
%   Returns a structure object with the following fields:
%	trace, spikes, spont_spike_shape, results, id, props.
%
% General methods of cip_trace_profile objects:
%   cip_trace_profile	- Construct a new cip_trace_profile object.
%   plot		- Graph the cip_trace_profile.
%   display		- Returns and displays the identification string.
%   get			- Gets attributes of this object and parents.
%   subsref		- Allows usage of . operator.
%
% Additional methods:
%   See methods('cip_trace_profile')
%
% See also: cip_trace, spikes, spike_shape
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/25

if nargin == 0 %# Called with no params, creates empty object
  obj.trace = trace;
  obj.spikes = spikes;
  obj.spont_spike_shape = spike_shape;
  obj.pulse_spike_shape = spike_shape;
  obj.props = struct([]);
  obj = class(obj, 'cip_trace_profile', results_profile);
elseif isa(varargin{1}, 'cip_trace_profile') %# copy constructor?
  obj = varargin{1};
elseif isnumeric(varargin{2})
  %# Create all data structures and collect results
  if nargin < 7
    props = struct([]);
  else
    props = varargin{7};
  end

  %# Create cip_trace
  obj.trace = cip_trace(varargin{1:6}, props); 

  %# Get spikes
  obj.spikes = spikes(obj.trace);

  %# Get spont spike_shape
  %# Prefix spike shape measures from different periods
  obj.spont_spike_shape = ...
      spike_shape(withinPeriod(obj.trace, periodIniSpont(obj.trace)), ...
		  withinPeriod(obj.spikes, periodIniSpont(obj.trace)));
  spont_sh_results = prefixStruct(getResults(obj.spont_spike_shape), 'Spont');

  obj.pulse_spike_shape  = ...
      spike_shape(withinPeriod(obj.trace, periodPulse(obj.trace)), ...
		  withinPeriod(obj.spikes, periodPulse(obj.trace)));
  pulse_sh_results = prefixStruct(getResults(obj.pulse_spike_shape), 'Pulse');

  %# Misc measures
  misc_results.PulseSpontAmpRatio = ...
      pulse_sh_results.PulseAmplitude / spont_sh_results.SpontAmplitude;

  obj.props = props;  

  %# Create the object
  %# Calculate trace & spikes tests
  %# Calculate all shape tests (using spike_shape.getResults)
  %# (Gets a NaN filled structure if no spikes found.)
  %# And merge them together
  obj = class(obj, 'cip_trace_profile', ...
	      results_profile(mergeStructs(getResults(obj.trace, obj.spikes), ...
					   spont_sh_results, pulse_sh_results, ...
					   misc_results), ...
			      varargin{6}));
else 
  %# Create object with custom data (used from subclasses)
  if nargin < 7
    props = struct([]);
  else
    props = varargin{7};
  end

  [ obj.trace, obj.spikes, obj.spont_spike_shape obj.pulse_spike_shape ] = ...
      deal(varargin{1:4});
  obj.props = props;

  %# Create the object
  obj = class(obj, 'cip_trace_profile', results_profile(varargin{5:6}));
end


