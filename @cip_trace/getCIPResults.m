function results = getCIPResults(a_cip_trace, a_spikes)

% getCIPResults - Calculate test results related to cip_trace.
%
% Usage:
% results = getCIPResults(a_cip_trace, a_spikes)
%
% Description:
%
%   Parameters:
%	a_cip_trace: A cip_trace object.
%	a_spikes: A spikes object.
%
%   Returns:
%	results: A structure associating test names with result values.
%
% See also: cip_trace, spikes, spike_shape
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/30

%# convert all to ms/mV
mV_factor = 1e3 * getDy(a_cip_trace);

results.PulsePotAvg = calcPulsePotAvg(a_cip_trace) * mV_factor;
results.RecSpontPotAvg = calcRecSpontPotAvg(a_cip_trace) * mV_factor;

%# Only if no spikes during pulse period
pulseSpikes = withinPeriod(a_spikes, periodPulse(a_cip_trace));
if length(pulseSpikes.times) == 0
  [min_val, min_idx, sag_val] = calcPulsePotSag(a_cip_trace);
  results.PulsePotMin = min_val * mV_factor;
  results.PulsePotSag = sag_val * mV_factor;
else
  results.PulsePotMin = NaN;
  results.PulsePotSag = NaN;
end
%# TODO: sag time constant?
