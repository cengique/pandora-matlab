function obj = getSpike(t, s, spike_num, props)

% getSpike - Convert a spike in the trace to a spike_shape object.
%
% Usage:
% obj = getSpike(trace, spikes, spike_num, props)
%
%   Parameters:
%	trace: A trace object.
%	spikes: A spikes object on trace.
%	spike_num: The index of spike to extract.
%
% Description:
%   Creates a spike_shape object from desired spike.
%		
% See also: spike_shape
%
% $Id$
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2005/04/19

if ~ exist('props')
  props = struct([]);
end

if nargin < 3 %# Called with insufficient params
  error('Need parameters.');
end

if spike_num < 1 || spike_num > length(s.times)
  error(['Spike index ' num2str(spike_num) ' is out of range. Only ' ...
	 num2str(length(s.times)) ' spikes in object.' ]);
end

spike_idx = s.times(spike_num);

if spike_num == 1 %# If first spike
  max_left = spike_idx - 1;
else
  max_left = max(0, spike_idx - s.times(spike_num - 1) - 3e-3 / t.dt);
end

%# Points from left side of peak, depends on existing data points
left = floor(min(5e-3 / t.dt, max_left));

if spike_num == length(s.times) %# if last spike
  max_right = length(get(t, 'data')) - spike_idx;
else
  max_right = max(0, s.times(spike_num + 1) - spike_idx - 3e-3 / t.dt);
end

%# Calculate right side accordingly
%# Add some more on the right side
right = floor(min(50e-3 / t.dt, max_right));
%#min_isi - left + floor(min(3e-3 / t.dt, left /2));

data = get(t, 'data');
obj = spike_shape(data((spike_idx - left):(spike_idx + right)), ...
		  t.dt, t.dy, [ t.id ' (spike#' num2str(spike_num) ')'], props);

