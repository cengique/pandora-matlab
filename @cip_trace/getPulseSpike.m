function obj = getPulseSpike(t, s, spike_num, props)

% getPulseSpike - Convert a spike in the CIP period to a spike_shape object.
%
% Usage:
% obj = getPulseSpike(trace, spikes, spike_num, props)
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
  props = struct;
end

props.spike_id = 'pulse';
obj = getSpike(withinPeriod(t, periodPulse(t)), withinPeriod(s, periodPulse(t)), ...
	       spike_num, props);
