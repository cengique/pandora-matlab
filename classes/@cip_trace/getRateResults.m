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
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/30

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

%# Spike rates [Hz] in total spikes over time method for all periods
ms_factor = 1e3 * get(a_cip_trace, 'dt');

%# Whole periods first
results.IniSpontSpikeRate = ...
    spikeRate(a_spikes, periodIniSpont(a_cip_trace));
results.IniSpontSpikeRateISI = ...
    spikeRateISI(a_spikes, periodIniSpont(a_cip_trace));
results.PulseSpikeRate = ...
    spikeRate(a_spikes, periodPulse(a_cip_trace));
results.PulseSpikeRateISI = ...
    spikeRateISI(a_spikes, periodPulse(a_cip_trace));
results.RecSpontSpikeRate = ...
    spikeRate(a_spikes, periodRecSpont(a_cip_trace));
results.RecSpontSpikeRateISI = ...
    spikeRateISI(a_spikes, periodRecSpont(a_cip_trace));

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
results.PulseIni100msRest1SpikeRateISI = ...
    spikeRateISI(a_spikes, periodPulseIni100msRest1(a_cip_trace));
results.PulseIni100msRest2SpikeRateISI = ...
    spikeRateISI(a_spikes, periodPulseIni100msRest2(a_cip_trace));
results.RecSpont1SpikeRate = ...
    spikeRate(a_spikes, periodRecSpont1(a_cip_trace));
results.RecSpont2SpikeRate = ...
    spikeRate(a_spikes, periodRecSpont2(a_cip_trace));
results.RecSpont1SpikeRateISI = ...
    spikeRateISI(a_spikes, periodRecSpont1(a_cip_trace));
results.RecSpont2SpikeRateISI = ...
    spikeRateISI(a_spikes, periodRecSpont2(a_cip_trace));

%# Add one to both num and denum to avoid Inf and NaNs, 
%# and still have discernible results
results.RecIniSpontRateRatio = ...
    (results.RecSpont1SpikeRateISI + 1) / (results.IniSpontSpikeRateISI + 1);

%# Whole pulse period rate methods compared

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

%# Recovery period
recov_spikes = withinPeriod(a_spikes, periodRecSpont(a_cip_trace));
if length(recov_spikes.times) > 1
  results.RecSpontFirstSpikeTime = recov_spikes.times(1) * ms_factor;
  recov_ISIs = getISIs(recov_spikes);
  results.RecSpontFirstISI = recov_ISIs(1) * ms_factor;
else
  results.RecSpontFirstSpikeTime = NaN;
  results.RecSpontFirstISI = NaN;
end