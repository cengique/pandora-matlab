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
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/04/26

%# Loop over spikes in each period
a_spikes = spikes(a_cip_trace);

%# Analyze spikes
[spont_results spont_spikes_db spont_spikes_stats_db spont_spikes_hists_dbs] = ...
    analyzeSpikesInPeriod(a_cip_trace, a_spikes, ...
			  periodIniSpont(a_cip_trace), 'Spont');
[pulse_results pulse_spikes_db pulse_spikes_stats_db pulse_spikes_hists_dbs] = ...
    analyzeSpikesInPeriod(a_cip_trace, a_spikes, ...
			  periodPulse(a_cip_trace), 'Pulse');
[recov_results recov_spikes_db recov_spikes_stats_db recov_spikes_hists_dbs] = ...
    analyzeSpikesInPeriod(a_cip_trace, a_spikes, ...
			  periodRecSpont(a_cip_trace), 'Recov');

%# TODO: rebuild the a_spikes object here, based on the spike dbs

%# Misc measures
misc_results.PulseSpontAmpRatio = ...
    pulse_results.PulseSpikeAmplitudeMean / spont_results.SpontSpikeAmplitudeMean;

%# All measures together
results_obj = ...
    results_profile(mergeStructs(getResults(a_cip_trace, a_spikes), ...
				 spont_results, pulse_results, recov_results, ...
				 misc_results), get(a_cip_trace, 'id'));

%# Create a new object with the spike dbs
profile_obj = cip_trace_allspikes_profile(a_cip_trace, a_spikes, spont_spikes_db, ...
					  pulse_spikes_db, recov_spikes_db, ...
					  results_obj, get(a_cip_trace, 'props'));

