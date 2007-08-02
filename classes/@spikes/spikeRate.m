function freq = spikeRate(s, a_period)

% spikeRate - Calculates the average firing rate [Hz] of the given spike train.
%
% Usage:
% freq = spikeRate(s, a_period)
%
% Description:
%
%   Parameters:
%	s: A spikes object.
%	a_period: The period where spikes were found (optional)
%
%   Returns:
%	freq: Firing rate [Hz]
%
% See also: spikes, period
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/03/09
% Modified:
% - Adapted to the spikes object, CG 2004/07/31

%# By default apply to the whole of s
if ~ exist('a_period')
  a_period = periodWhole(s);
else
  s = withinPeriod(s, a_period);
end

freq = length(s.times) / ( s.dt * (a_period.end_time - a_period.start_time ));

