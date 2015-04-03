function [results, period_spikes, a_spikes_db, spikes_stats_db, spikes_hists_dbs] = ...
  analyzeSpikesInPeriod(a_trace, a_spikes, period, prefix_str)

% analyzeSpikesInPeriod - Returns results and a db of spikes by collecting test results of a trace, analyzing each individual spike.
%
% Usage:
% [results period_spikes a_spikes_db spikes_stats_db spikes_hists_dbs] =
%      analyzeSpikesInPeriod(a_trace, a_spikes, period, prefix_str)
%
%   Parameters:
%	a_trace: A trace object.
%	a_spikes: A spikes object from the a_trace object.
%	period: A period of object of a_trace object of interest.
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
% See also: trace, spikes, period, spike_shape, getProfileAllSpikes
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/05/04

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

ms_factor = 1e3 * get(a_trace, 'dt');

period_trace = withinPeriod(a_trace, period);
period_spikes = withinPeriod(a_spikes, period);
num_spikes = length(period_spikes.times);

% pre-allocate struct array with empty spike shape
empty_results = getResults(spike_shape);
empty_results.Index = NaN;
empty_results.Time = NaN;
[spike_results(1:max(num_spikes, 1), 1)] = deal(empty_results);

% Collect spike shape analysis results,
% -Index and -Time fields allow to regenerate spikes object.
if num_spikes > 0
  period_spikes_new = set(period_spikes, 'times', []);
  
  for spike_num = 1:num_spikes
    try
      % Convert a spike in the trace to a spike_shape object
      s = getSpike(period_trace, period_spikes, spike_num, ...
        struct('spike_id', prefix_str));
      
      % Runs all tests defined by this class and return them in a structure.
      a_results = getResults(s);
      a_results.Index = spike_num;
      spike_time = period_spikes.times(spike_num);
      period_spikes_new = addSpikes(period_spikes_new, spike_time);
      a_results.Time = spike_time * ms_factor;
      spike_results(spike_num) = a_results;
    catch
      err = lasterror;
      if strcmp(err.identifier, 'spike_shape:not_a_spike')
        % TODO: remove this spike from the a_spikes object
        % Leave as empty shape object
        warning('spike_shape:info', ...
          [ 'Deleting spike: %s because:' ...
          sprintf('\n') err.message ], get(s, 'id'));
      else
        warning('trace:info', 'Rethrowing error in %s spikes:', prefix_str);
        rethrow(err);
      end
    end
  end
else % No spikes
  % Keep empty shape results
  period_spikes_new = period_spikes;
end

test_names = fieldnames(spike_results);
num_tests = length(test_names);

% make a small db from results
% TODO: make a spikes_db for customized result collection (to plot results?)
% TODO: add spike number/time as parameter
results_matx = cell2mat(struct2cell(spike_results))';
a_spikes_db = spikes_db(results_matx, test_names, period_trace, period_spikes, ...
  [ prefix_str ' spikes of ' get(a_trace, 'id') ]);

% find mean, std (except the -Index and -Time fields)
spikes_stats_db = statsMeanStd(onlyRowsTests(a_spikes_db, ':', 1:(num_tests - 2)));

% calculate histogram on each measure array
% find mode, and maybe a measure of number and spread of local extrema
spikes_hists_dbs = testsHists(a_spikes_db);

prefix_str = [prefix_str 'Spike'];

results.([prefix_str 's']) = num_spikes;
% create result names and values (except the -Index and -Time fields)
for test_num = 1:(num_tests - 2)
  results.([prefix_str test_names{test_num} 'Mean' ]) = ...
    spikes_stats_db.data(1, test_num);
  results.([prefix_str test_names{test_num} 'STD' ]) = ...
    spikes_stats_db.data(2, test_num);
  [mode_val, mode_mag] = calcMode(spikes_hists_dbs(test_num));
  if verbose
    disp([ prefix_str ' ' test_names{test_num} ':  mode_val=' num2str(mode_val) ...
      ', mode_mag=' num2str(mode_mag)]);
  end
  results.([prefix_str test_names{test_num} 'Mode' ]) = mode_val;
  % TODO: add the unimodality measure and median here
end

period_spikes = period_spikes_new;
