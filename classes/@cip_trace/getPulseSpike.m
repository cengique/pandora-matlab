function obj = getPulseSpike(t, s, spike_num, props)

% getPulseSpike - Convert a spike in the CIP period to a spike_shape object.
%
% Usage:
% obj = getPulseSpike(trace, spikes, spike_num, props)
%
% Parameters:
%	trace: A trace object.
%	spikes: (Optional) A spikes object obtained from trace, 
%		calculated automatically if given as [].
%	spike_num: The index of spike to extract.
%	props: A structure with any optional properties passed to getSpike.
%
% Description:
%   Creates a spike_shape object from desired spike. Calls trace/getSpike method.
%
% Example:
% Get 2nd pulse spike and plot it:
% >> plotFigure(plotResults(getPulseSpike(t, [], 2)))
%		
% See also: spike_shape, trace/getSpike
%
% $Id$
%
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2005/04/19

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props')
  props = struct;
end

num_traces = length(t);
num_spikes = length(s);

% If called with array of traces
if num_traces > 1
  % If also passed array of spikes objects
  if num_spikes > 1
    if num_spikes ~= num_traces
      error(['Length of trace (' num_traces ') and spikes (' num_spikes ...
							   ') arrays must be equal.']);
    end
    for trace_num = 1:num_traces
      obj(trace_num) = getPulseSpike(t(trace_num), s(trace_num), spike_num, props);
    end
  else
    for trace_num = 1:num_traces
      obj(trace_num) = getPulseSpike(t(trace_num), s, spike_num, props);
    end
  end
  return;
end

if isempty(s)
  s = spikes(t);
end

props.spike_id = 'pulse';
obj = getSpike(withinPeriod(t, periodPulse(t)), withinPeriod(s, periodPulse(t)), ...
	       spike_num, props);
