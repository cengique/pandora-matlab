function obj = spike_shape(data, dt, dy, id, props)

% spike_shape - An averaged action potential profile from a trace.
%
% Usage:
% obj = spike_shape(data, dt, dy, id)
%
% Description:
%		
% Uses the generic trace object to store an averaged spike shape. 
% Inherits the common methods defined in trace.
%
%   Parameters:
%	data: A vector of data points containing the spike shape.
%	dt: Time resolution [s].
%	dy: y-axis resolution [ISI (V, A, etc.)]
%	id: Identification string.
%	props: A structure with any optional properties.
%		baseline: Resting potential.
%		threshold: Spike threshold.
%		init_Vm_method: Method to obtain spike initiation voltage.
%		init_threshold: Spike initiation threshold (deriv or accel).
%				(see calcInitVm)
%
%   Returns a structure object with the following fields:
%	trace, props.
%
% General methods of spike_shape objects:
%   spike_shape		- Construct a new spike_shape object.
%   calcMinVm		- Returns the value and index of the minimal Vm point.
%   calcMaxVm		- Returns the value and index of the maximal Vm point.
%   calcInitVm		- Returns the value and index of the spike initiation point.
%   calcWidthFall	- Returns the spike witdth and fall information
%   getResults		- Calculates a set of tests.
%
% Additional methods:
%   See methods('spike_shape')
%
% See also: trace/spike_shape, trace, spikes, period
%
% $Id$
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2004/07/30
%   Based on spike_trace of Jeremy Edgerton.

if nargin == 0 %# Called with no params
  trace_obj = trace;
  obj.props = struct([]);
  obj = class(obj, 'spike_shape', trace_obj);
elseif isa(data, 'spike_shape') %# copy constructor?
  obj = data;
else
  trace_obj = trace(data, dt, dy, id, struct([]));

  if ~ exist('props')
    props.init_Vm_method = 4; %# Sekerli's method
    %#props.init_threshold = 15; %# Derivative in V/s (= mV/ms)
  end
  obj.props = props;

  obj = class(obj, 'spike_shape', trace_obj);
end

