function freq = spikeRateISI(s, a_period)

% spikeRateISI - Calculates the firing rate of the spikes found in the given 
%		period with an averaged inter-spike-interval approach.
%
% Usage:
% freq = spikeRateISI(s, trace_index, times, period)
%
% Description:
%   Parameters:
%	s: A spikes object.
%	period: The period where spikes were found (optional)
%
%   Returns:
%	freq: Firing rate [Hz]
%
% See also: trace, spikes, period
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/03/09
% Modified:
% - Adapted to the spikes object, CG 2004/07/31

%# By default apply to the whole of s
if ~ exist('a_period')
  a_period = periodWhole(s);
else
  s = withinPeriod(s, a_period);
end

freq = meanSpikeFreq(s.times, s.dt, (a_period.end_time - a_period.start_time ));

