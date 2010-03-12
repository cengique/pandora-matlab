function obj = spike_shape(data, dt, dy, id, props)

% spike_shape - An action potential shape trace.
%
% Usage:
% obj = spike_shape(data, dt, dy, id)
%
% Description:
%		
% Uses the generic trace object to store a spike shape that can be obtained from
% another trace. Inherits the common methods defined in trace. See trace/spike_shape
% for getting average spike shapes from a trace. trace/analyzeSpikesInPeriod 
% finds each spike and analyzes separately.
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
%			4- maximum acceleration in phase space
%			   (optionally specify maximal threshold as init_threshold)
%			5- point of maximum curvature, when slope is between 
%			   init_lo_thr and init_hi_thr
%			6- local maximum of second derivative in the phase space
%			   nearest slope crossing init_threshold
%			7- threshold crossing of interpolated slope (needs threshold)
%			8- maximum curvature in phase-plane
%			9- Combined curvature and inflection method in time-domain.
%		init_threshold: Spike initiation threshold (deriv or accel).
%				(see above methods and implementation in calcInitVm)
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
% See also: trace/spike_shape, trace/analyzeSpikesInPeriod, trace, spikes, period
%
% $Id$
%
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2004/07/30
%   Based on spike_trace of Jeremy Edgerton.

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 % Called with no params
  trace_obj = trace;
  obj = class(struct([]), 'spike_shape', trace_obj);
elseif isa(data, 'spike_shape') % copy constructor?
  obj = data;
else

  if ~ exist('props', 'var')
    props = struct;
  end

  if ~ isfield(props, 'init_Vm_method')
    %props.init_Vm_method = 6; % Sekerli's method
    %props.init_threshold = 10; % upper bound of derivative in V/s (= mV/ms)
    % (no upper bound works more reliably)
    % OR
    %props(1).init_Vm_method = 7; % supersampled derivative threshold method
    
    % max vPP curvature, fallback on derivative threshold method
    props.init_Vm_method = 8; 
    % threshold crossing derivative in V/s (= mV/ms)
    % do not overwrite if already set
    if ~ isfield(props, 'init_threshold')
      props.init_threshold = 15; 
    end
  end

  trace_obj = trace(data, dt, dy, id, props);
  obj = class(struct([]), 'spike_shape', trace_obj);
end
