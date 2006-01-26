function results = getBurstResults(a_cip_trace, a_spikes)

% getBurstResults - Calculate test results related to Burst behavior.
%
% Usage:
% results = getRateResults(a_cip_trace, a_spikes)
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
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/30, Tom Sangrey
% 2006/1/23

%# Spike rates [Hz] in total spikes over time method for all periods
ms_factor = 1e3 * get(a_cip_trace, 'dt');


%# Exponential approximation to amplitude decay for slow inactivating channels
[a_tau, a_inf] = spikeAmpSlope(a_spikes, a_cip_trace, ...
			       periodPulse(a_cip_trace));
results.SlowRD_ISIdecayTime = a_tau;
results.SlowRD_ISIchange = a_inf;

