function obj = getProfileAllSpikes(a_cip_trace)

% getProfileAllSpikes - Creates a results_profile object by collecting test results of a cip_trace, analyzing each individual spike.
%
% Usage:
% obj = 
%   getProfileAllSpikes(a_cip_trace)
%   Parameters:
%	a_cip_trace: A cip_trace object.
%
% Description:
% 
%   Returns a structure object with the following fields:
%	trace, spikes, results, id, props.
%
% See also: cip_trace, spikes, spike_shape, cip_trace_profile
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/04/26

%# Loop over spikes in each period
a_spikes = spikes(a_cip_trace);

%# Analyze spikes
spont_results = analyzeSpikesInPeriod(a_cip_trace, a_spikes, ...
				      periodIniSpont(a_cip_trace), 'Spont');
pulse_results = analyzeSpikesInPeriod(a_cip_trace, a_spikes, ...
				      periodPulse(a_cip_trace), 'Pulse');
recov_results = analyzeSpikesInPeriod(a_cip_trace, a_spikes, ...
				      periodRecSpont(a_cip_trace), 'Recov');

%# Misc measures
misc_results.PulseSpontAmpRatio = ...
    pulse_results.PulseSpikeAmplitudeMean / spont_results.SpontSpikeAmplitudeMean;

%# TODO: create a new object with the spike dbs

%# All measures together
obj = results_profile(mergeStructs(getResults(a_cip_trace, a_spikes), ...
				   spont_results, pulse_results, recov_results, ...
				   misc_results), get(a_cip_trace, 'id'));

%# TODO: make this a standalone method
function [results spikes_db spikes_stats_db spikes_hists_dbs] = ...
      analyzeSpikesInPeriod(a_cip_trace, a_spikes, period, prefix_str)
  period_trace = withinPeriod(a_cip_trace, period);
  period_spikes = withinPeriod(a_spikes, period);
  num_spikes = length(period_spikes.times);

  %# Collect spike shape analysis results,
  %# pre-allocate struct array with results from first spike
  [spike_results(1:num_spikes, 1)] = ...
      deal(getResults(getSpike(period_trace, period_spikes, 1)));

  if num_spikes > 1
    for spike_num = 2:num_spikes
      spike_results(spike_num) = ...
	  getResults(getSpike(period_trace, period_spikes, spike_num));
    end
  end

  test_names = fieldnames(spike_results);
  num_tests = length(test_names);
  
  %# make a small db from results
  %# TODO: make a spikes_db for customized result collection
  %# TODO: add spike number as parameter
  results_matx = cell2mat(struct2cell(spike_results))';
  spikes_db = tests_db(results_matx, test_names, {}, ...
		       [ prefix_str ' spikes of ' get(a_cip_trace, 'id') ]);

  %# find mean, std
  spikes_stats_db = statsMeanStd(spikes_db);
  
  %# calculate histogram on each measure array
  %# find mode, and maybe a measure of number and spread of local extrema
  spikes_hists_dbs = testsHists(spikes_stats_db);
  
  prefix_str = [prefix_str 'Spike'];

  results.([prefix_str 's']) = num_spikes;
  %# create result names and values
  for test_num = 1:num_tests
    results.([prefix_str test_names{test_num} 'Mean' ]) = ...
	spikes_stats_db.data(1, test_num);
    results.([prefix_str test_names{test_num} 'STD' ]) = ...
	spikes_stats_db.data(2, test_num);
    [mode_val, mode_mag] = mode(spikes_hists_dbs(test_num));
    results.([prefix_str test_names{test_num} 'Mode' ]) = mode_val;
    %# TODO: add the unimodality measure here
  end
