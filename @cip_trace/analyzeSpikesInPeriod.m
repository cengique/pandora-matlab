function [results, period_spikes, a_spikes_db, spikes_stats_db, spikes_hists_dbs] = ...
      analyzeSpikesInPeriod(a_cip_trace, a_spikes, period, prefix_str)

% analyzeSpikesInPeriod - Returns results and a db of spikes by collecting test results of a cip_trace, analyzing each individual spike.
%
% Usage:
% [results period_spikes a_spikes_db spikes_stats_db spikes_hists_dbs] =
%      analyzeSpikesInPeriod(a_cip_trace, a_spikes, period, prefix_str)
%
%   Parameters:
%	a_cip_trace: A cip_trace object.
%	a_spikes: A spikes object from the a_cip_trace object.
%	period: A period of object of a_cip_trace object of interest.
%	prefix_str: Prefix string to be added to spike shape results.
%
% Description:
%
% Returns:
%	results: Results structure names prefixed with prefix_str.
%	period_spikes: Corrected spikes object for this period.
%	a_spikes_db: A mini spikes database of results from each spike in period. 
%	spikes_stats_db: Statistics from the mini spikes database.
%	spikes_hists_dbs: Cell array of histograms from the mini spikes database.
% 
% See also: cip_trace, spikes, period, spike_shape, getProfileAllSpikes
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/05/04

%# TODO: move this to trace?

  vs = warning('query', 'verbose');
  verbose = strcmp(vs.state, 'on');

  period_trace = withinPeriod(a_cip_trace, period);
  period_spikes = withinPeriod(a_spikes, period);
  num_spikes = length(period_spikes.times);

  %# Collect spike shape analysis results,
  %# pre-allocate struct array with results from first spike
  %# TODO: pre-allocate only with empty spike shape
  %#  - add -Index and -Time fields to be able to regenerate spikes object?
  if num_spikes > 0
    empty_results = getResults(spike_shape);
    empty_results.Index = NaN;
    empty_results.Time = NaN;
    [spike_results(1:num_spikes, 1)] = deal(empty_results);      
    period_spikes_new = set(period_spikes, 'times', []);
	  
    for spike_num = 1:num_spikes
      try 
	s = getSpike(period_trace, period_spikes, spike_num, ...
		     struct('spike_id', prefix_str));
	a_results = getResults(s);
	a_results.Index = spike_num;
	a_results.Time = period_spikes.times(spike_num);
	spike_results(spike_num) = a_results;
	period_spikes_new = addSpikes(period_spikes_new, a_results.Time);
      catch
	err = lasterror;
	if strcmp(err.identifier, 'spike_shape:not_a_spike')
	  %# TODO: remove this spike from the a_spikes object
	  %# Leave as empty shape object
	  warning('spike_shape:info', 'Not a spike: %s.', get(s, 'id'))
	else
	  warning('cip_trace:info', 'Rethrowing error in %s spikes:', prefix_str);
	  rethrow(err);
	end
      end
    end
  else %# No spikes
    %# Assign empty shape object
    [spike_results(1, 1)] = deal(getResults(spike_shape));
    period_spikes_new = period_spikes;
  end

  test_names = fieldnames(spike_results);
  num_tests = length(test_names);
  
  %# make a small db from results
  %# TODO: make a spikes_db for customized result collection (to plot results?)
  %# TODO: add spike number/time as parameter
  results_matx = cell2mat(struct2cell(spike_results))';
  a_spikes_db = tests_db(results_matx, test_names, {}, ...
			 [ prefix_str ' spikes of ' get(a_cip_trace, 'id') ]);

  %# find mean, std (except the -Index and -Time fields)
  spikes_stats_db = statsMeanStd(onlyRowsTests(a_spikes_db, ':', 1:(num_tests - 2)));
  
  %# calculate histogram on each measure array
  %# find mode, and maybe a measure of number and spread of local extrema
  spikes_hists_dbs = testsHists(a_spikes_db);
  
  prefix_str = [prefix_str 'Spike'];

  results.([prefix_str 's']) = num_spikes;
  %# create result names and values (except the -Index and -Time fields)
  for test_num = 1:(num_tests - 2)
    results.([prefix_str test_names{test_num} 'Mean' ]) = ...
	spikes_stats_db.data(1, test_num);
    results.([prefix_str test_names{test_num} 'STD' ]) = ...
	spikes_stats_db.data(2, test_num);
    [mode_val, mode_mag] = mode(spikes_hists_dbs(test_num));
    if verbose
      disp([ prefix_str ' ' test_names{test_num} ':  mode_val=' num2str(mode_val) ...
	    ', mode_mag=' num2str(mode_mag)]);
    end
    results.([prefix_str test_names{test_num} 'Mode' ]) = mode_val;
    %# TODO: add the unimodality measure and median here
  end

  period_spikes = period_spikes_new;