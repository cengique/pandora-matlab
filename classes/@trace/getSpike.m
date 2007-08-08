function obj = getSpike(t, s, spike_num, props)

% getSpike - Convert a spike in the trace to a spike_shape object.
%
% Usage:
% obj = getSpike(trace, spikes, spike_num, props)
%
% Description:
%   Creates a spike_shape object from desired spike. It is more efficient if
% you already have the spikes object.
%		
% Parameters:
%	trace: A trace object.
%	spikes: (Optional) A spikes object obtained from trace, 
%		calculated automatically if given as [].
%	spike_num: The index of spike to extract.
%	props: A structure with any optional properties.
%	  spike_id: A prefix string added to the spike_shape object's id.
%
% Example:
% This will create an annotated plot of the third spike in my_trace:
% >> plotFigure(plotResults(getSpike(my_trace, [], 3)))
%
% See also: spike_shape
%
% $Id$
%
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2005/04/19

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

if ~ exist('props')
  props = struct([]);
end

num_traces = length(t);
num_spikes = length(s);

%# If called with array of traces
if num_traces > 1
  %# If also passed array of spikes objects
  if num_spikes > 1
    if num_spikes ~= num_traces
      error(['Length of trace (' num_traces ') and spikes (' num_spikes ...
							   ') arrays must be equal.']);
    end
    for trace_num = 1:num_traces
      obj(trace_num) = getSpike(t(trace_num), s(trace_num), spike_num, props);
    end
  else
    for trace_num = 1:num_traces
      obj(trace_num) = getSpike(t(trace_num), [], spike_num, props);
    end
  end
  return;
end

if isempty(s)
  s = spikes(t);
end

trace_props = get(trace, 'props');

%# Copy some props from trace to spike_shape
copy_from_trace = {'init_Vm_method', 'init_threshold', 'init_lo_thr', 'init_hi_thr'};
for i=1:length(copy_from_trace)
  if isfield(trace_props, copy_from_trace{i})
    props.(copy_from_trace{i}) = trace_props.(copy_from_trace{i});
  end
end

if spike_num < 1 || spike_num > length(s.times)
  error('getSpike:no_spikes', ['Spike index ' num2str(spike_num) ' is out of range. Only ' ...
	 num2str(length(s.times)) ' spikes in object.' ]);
end

spike_idx = s.times(spike_num);

if spike_num == 1 %# If first spike
  max_left = spike_idx - 1;
else
  %# Minimal 1 ms
  max_left = max(1e-3 / t.dt, spike_idx - s.times(spike_num - 1) - 3e-3 / t.dt);
end

%# Points from left side of peak, depends on existing data points
left = floor(min(7e-3 / t.dt, max_left));

if spike_num == length(s.times) %# if last spike
  max_right = length(get(t, 'data')) - spike_idx;
else
  max_right = max(0, s.times(spike_num + 1) - spike_idx - 1e-3 / t.dt);
end

%# Calculate right side accordingly
%# Add some more on the right side
right = floor(min(50e-3 / t.dt, max_right));
%#min_isi - left + floor(min(3e-3 / t.dt, left /2));

if isfield(props, 'spike_id')
  spike_id_prefix = [ props.spike_id ' '];
else
  spike_id_prefix = '';
end

data = get(t, 'data');
obj = spike_shape(data((spike_idx - left):(spike_idx + right)), ...
		  t.dt, t.dy, [ t.id ' (' spike_id_prefix ...
					'spike#' num2str(spike_num) ')'], props);

