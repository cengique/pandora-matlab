function obj = getPulseSpike(t, s, spike_num, props)

% getPulseSpike - Convert a spike in the CIP period to a spike_shape object.
%
% Usage 1:
% obj = getPulseSpike(trace, spike_num, props)
%
% Usage 2:
% obj = getPulseSpike(trace, spikes, spike_num, props)
%
%   Parameters:
%	trace: A trace object.
%	spikes: A spikes object on trace.
%	spike_num: The index of spike to extract.
%	props: A structure with any optional properties passed to getSpike.
%
% Description:
%   Creates a spike_shape object from desired spike. Calls trace/getSpike method.
%
% Example:
% Get 2nd pulse spike and plot it:
% >> plotFigure(plotResults(getPulseSpike(t, 2)))
%		
% See also: spike_shape, trace/getSpike
%
% $Id$
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2005/04/19

if ~ exist('props')
  props = struct;
end

if isnumeric(s)
  if exist('spike_num')
    props = spike_num;
  else
    props = struct;
  end
  spike_num = s;
  s = spikes(t);
end

props.spike_id = 'pulse';
obj = getSpike(withinPeriod(t, periodPulse(t)), withinPeriod(s, periodPulse(t)), ...
	       spike_num, props);
