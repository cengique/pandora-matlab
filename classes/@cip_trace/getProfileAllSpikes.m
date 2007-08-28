function profile_obj = getProfileAllSpikes(a_cip_trace)

% getProfileAllSpikes - Creates a cip_trace_allspikes_profile object by collecting test results of a cip_trace, analyzing each individual spike.
%
% Usage:
% profile_obj = getProfileAllSpikes(a_cip_trace)
%
%   Parameters:
%	a_cip_trace: A cip_trace object.
%
%   Returns:
%	profile_obj: A cip_trace_allspikes_profile object.
%
% Description:
%   Analyzes the spontaneous (periodIniSpont), pulse (periodPulse) and the
% recovery (periodRecSpont) periods separately and produces spike shape
% distribution results. Rate and CIP measurements are added to these.
% 
% See also: cip_trace, cip_trace_allspikes_profile
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/04/26

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

%# Loop over spikes in each period
a_spikes = spikes(a_cip_trace);

%# Analyze spikes
spont_period = periodIniSpont(a_cip_trace);
[spont_results spont_spikes spont_spikes_db ...
 spont_spikes_stats_db spont_spikes_hists_dbs] = ...
    analyzeSpikesInPeriod(a_cip_trace, a_spikes, spont_period, 'Spont');

pulse_period = periodPulse(a_cip_trace);
[pulse_results pulse_spikes pulse_spikes_db ...
 pulse_spikes_stats_db pulse_spikes_hists_dbs] = ...
    analyzeSpikesInPeriod(a_cip_trace, a_spikes, pulse_period, 'Pulse');

recov_period = periodRecSpont(a_cip_trace);
[recov_results recov_spikes recov_spikes_db ...
 recov_spikes_stats_db recov_spikes_hists_dbs] = ...
    analyzeSpikesInPeriod(a_cip_trace, a_spikes, ...
			  recov_period, 'Recov');

%# TODO: rebuild the a_spikes object here, based on the spike dbs
new_spikes = [intoPeriod(spont_spikes, spont_period); ...
	      intoPeriod(pulse_spikes, pulse_period); ...
	      intoPeriod(recov_spikes, recov_period)];

%# Misc measures
misc_results.PulseSpontAmpRatio = ...
    pulse_results.PulseSpikeAmplitudeMean / spont_results.SpontSpikeAmplitudeMean;

%# All measures together
results_obj = ...
    results_profile(mergeStructs(getResults(a_cip_trace, new_spikes), ...
				 spont_results, pulse_results, recov_results, ...
				 misc_results), get(a_cip_trace, 'id'));

%# Create a new object with the spike dbs
profile_obj = cip_trace_allspikes_profile(a_cip_trace, new_spikes, spont_spikes_db, ...
					  pulse_spikes_db, recov_spikes_db, ...
					  results_obj, get(a_cip_trace, 'props'));

