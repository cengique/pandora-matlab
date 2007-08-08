function results = getCIPResults(a_cip_trace, a_spikes)

% getCIPResults - Calculate test results about CIP protocol.
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
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/30

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

%# convert all to ms/mV
mV_factor = 1e3 * getDy(a_cip_trace);
ms_factor = 1e3 * get(a_cip_trace, 'dt');

results.IniSpontPotAvg = calcAvg(a_cip_trace.trace, ...
				 periodIniSpont(a_cip_trace));
results.PulsePotAvg = calcPulsePotAvg(a_cip_trace) * mV_factor;
results.RecSpontPotAvg = calcRecSpontPotAvg(a_cip_trace) * mV_factor;
results.RecIniSpontPotRatio = results.RecSpontPotAvg / results.IniSpontPotAvg;

%# Only if no spikes during pulse period
pulse_period = periodPulse(a_cip_trace);
pulse_spikes = withinPeriod(a_spikes, pulse_period);
if length(pulse_spikes.times) == 0
  [min_val, min_idx, sag_val] = calcPulsePotSag(a_cip_trace);
  results.PulsePotMin = min_val * mV_factor;
  results.PulsePotMinTime = min_idx * ms_factor;
  results.PulsePotSag = sag_val * mV_factor;
  if ~ isnan(min_idx)
    results.PulsePotTau = ...
	memTimeConstant(a_cip_trace, min_idx, min_val, ...
			results.IniSpontPotAvg / mV_factor ) * ms_factor;
  else
    results.PulsePotTau = NaN;
  end
else
  results.PulsePotMin = NaN;
  results.PulsePotMinTime = NaN;
  results.PulsePotSag = NaN;
  results.PulsePotTau = NaN;
end

%# membrane time constant from sag
function time_constant = memTimeConstant(a_cip_trace, min_idx, min_val, rest_val)
  pulse_data = get(withinPeriod(a_cip_trace, periodPulse(a_cip_trace)), 'data');
  
  %#rest_val = pulse_data(1);
  drop_val = rest_val - min_val;

  decay_constant_threshold = rest_val - drop_val * (1 - exp(-1));

  recover_times = find(pulse_data(1:min_idx) < decay_constant_threshold);
  
  if length(recover_times) > 0
    time_constant = recover_times(1);
  else
    time_constant = NaN;
  end
