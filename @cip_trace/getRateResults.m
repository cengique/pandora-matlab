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

%# Whole periods first
results.IniSpontSpikeRate = ...
    spikeRate(a_spikes, periodIniSpont(a_cip_trace));
results.PulseSpikeRate = ...
    spikeRate(a_spikes, periodPulse(a_cip_trace));
results.RecSpontSpikeRate = ...
    spikeRate(a_spikes, periodRecSpont(a_cip_trace));

%# Then Subperiods
results.PulseIni100msSpikeRateISI = ...
    spikeRateISI(a_spikes, periodPulseIni100ms(a_cip_trace));
results.PulseIni100msISICV = ...
    ISICV(a_spikes, periodPulseIni100ms(a_cip_trace));
results.PulseIni100msSpikeRate = ...
    spikeRate(a_spikes, periodPulseIni100ms(a_cip_trace));
results.PulseIni100msRest1SpikeRate = ...
    spikeRate(a_spikes, periodPulseIni100msRest1(a_cip_trace));
results.PulseIni100msRest2SpikeRate = ...
    spikeRate(a_spikes, periodPulseIni100msRest2(a_cip_trace));
results.RecSpont1SpikeRate = ...
    spikeRate(a_spikes, periodRecSpont1(a_cip_trace));
results.RecSpont2SpikeRate = ...
    spikeRate(a_spikes, periodRecSpont2(a_cip_trace));

if results.IniSpontSpikeRate ~= 0 
  results.RecIniSpontRateRatio = ...
      results.RecSpont1SpikeRate / results.IniSpontSpikeRate;
else
  results.RecIniSpontRateRatio = NaN;
end

%# Whole pulse period rate methods compared
results.PulseSpikeRateISI = ...
    spikeRateISI(a_spikes, periodPulse(a_cip_trace));

%# ISI-CV 
results.IniSpontISICV = ISICV(a_spikes, periodIniSpont(a_cip_trace));
results.PulseISICV = ISICV(a_spikes, periodPulse(a_cip_trace));
results.RecSpontISICV = ISICV(a_spikes, periodRecSpont(a_cip_trace));

%# Spike frequency accommodation (SFA)
results.PulseSFA = SFA(a_spikes, periodPulse(a_cip_trace));

%# Exponential approximation to amplitude decay for slow inactivating channels
[a_tau, a_inf] = spikeAmpSlope(a_spikes, a_cip_trace, ...
			       periodPulse(a_cip_trace));
results.PulseSpikeAmpDecayTau = a_tau;
results.PulseSpikeAmpDecayDelta = a_inf;
