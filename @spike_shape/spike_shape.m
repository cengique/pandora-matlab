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
%			1- maximum acceleration point
%			2- threshold crossing of acceleration (needs threshold)
%			3- threshold crossing of slope (needs threshold)
%			4- maximum second derivative in the phase space
%			   (optionally specify maximal threshold as init_threshold)
%			5- point of maximum curvature, when slope is between 
%			   init_lo_thr and init_hi_thr
%			6- local maximum of second derivative in the phase space
%			   nearest slope crossing init_threshold
%		init_threshold: Spike initiation threshold (deriv or accel).
%				(see calcInitVm)
%		init_lo_thr, init_hi_thr: Low and high thresholds for slope.
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
    props.init_Vm_method = 6; %# Sekerli's method
    props.init_threshold = 10; %# upper bound of derivative in V/s (= mV/ms)
    %# (no upper bound works more reliably)
    %# OR
    %#props.init_Vm_method = 3; %# Derivative threshold method
    %#props.init_threshold = 15; %# threshold crossing derivative in V/s (= mV/ms)
  end
  obj.props = props;

  obj = class(obj, 'spike_shape', trace_obj);
end

