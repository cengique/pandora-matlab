function obj = spikes(times, num_samples, dt, id)

% spikes - Spike times from a trace.
%
% Usage:
% obj = spikes(times, num_samples, dt, id)
%
%   Parameters:
%	times: The spike times [dt].
%	num_samples: Number of samples in the original trace.
%	dt: Time resolution [s].
%	id: Identification string.
%
% Description:
%		
%   Returns a structure object with the following fields:
%	times, dt, id.
%
% General methods of spikes objects:
%   spikes		- Construct a new spikes object.
%   plot		- Graph the spikes.
%   display		- Returns and displays the identification string.
%   spikeRate		- Average spike rate [Hz].
%   spikeRateISI	- Average spike rate, calculated from ISIs [Hz].
%   spikeISIs		- Vector of spike ISIs [dt].
%   withinPeriod 	- Returns a spikes object valid only within the 
%			given period.
%
% Additional methods:
%   See methods('spikes')
%
% See also: trace/spikes, trace, spike_shape, period
%
% $Id$
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2004/07/30
%   Inspired by cip_dataset of Jeremy Edgerton.

if nargin == 0 %# Called with no params
   obj.times = [];
   obj.num_samples = 0;
   obj.dt = 1;
   obj.id = '';
   obj = class(obj, 'spikes');
 elseif isa(times,'spikes') %# copy constructor?
   obj = times;
 else
   obj.times = times;
   obj.num_samples = num_samples;
   obj.dt = dt;
   obj.id = id;
   obj = class(obj, 'spikes');
end

