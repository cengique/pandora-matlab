function results = getRateResults(a_cip_trace, a_spikes)

% getRateResults - Calculate test results related to spike rate.
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
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/30

%# Spike rates [Hz] in total spikes over time method for all periods
results.IniSpontSpikeRate = ...
    spikeRate(a_spikes, periodIniSpont(a_cip_trace));
results.PulseIni50msSpikeRate = ...
    spikeRate(a_spikes, periodPulseIni50ms(a_cip_trace));
results.PulseIni50msRest1SpikeRate = ...
    spikeRate(a_spikes, periodPulseIni50msRest1(a_cip_trace));
results.PulseIni50msRest2SpikeRate = ...
    spikeRate(a_spikes, periodPulseIni50msRest2(a_cip_trace));
results.RecSpont1SpikeRate = ...
    spikeRate(a_spikes, periodRecSpont1(a_cip_trace));
results.RecSpont2SpikeRate = ...
    spikeRate(a_spikes, periodRecSpont2(a_cip_trace));

%# Whole pulse period rate methods compared
results.PulseSpikeRate = ...
    spikeRate(a_spikes, periodPulse(a_cip_trace));
results.PulseSpikeRateISI = ...
    spikeRateISI(a_spikes, periodPulse(a_cip_trace));

%# ISI-CV 
results.PulseISICV = ISICV(a_spikes, periodPulse(a_cip_trace));

