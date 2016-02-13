function profile_obj = getProfileAllSpikes(a_trace)

% getProfileAllSpikes - Creates a trace_allspikes_profile object by collecting test results of a trace, analyzing each individual spike.
%
% Usage:
% profile_obj = getProfileAllSpikes(a_trace)
%
%   Parameters:
%	a_trace: A trace object.
%
%   Returns:
%	profile_obj: A trace_allspikes_profile object.
%
% Description:
%   Analyzes the spontaneous (periodIniSpont), pulse (periodPulse) and the
% recovery (periodRecSpont) periods separately and produces spike shape
% distribution results. Rate and CIP measurements are added to these.
% 
% See also: trace, trace_allspikes_profile
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/04/26

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Loop over spikes in each period
a_spikes = spikes(a_trace, []);

% Analyze spikes in entire period.
whole_period = periodWhole(a_trace);
[whole_results whole_spikes whole_spikes_db ...
 whole_spikes_stats_db whole_spikes_hists_dbs] = ...
    analyzeSpikesInPeriod(a_trace, a_spikes, whole_period, '');

results_obj = ...
    results_profile(mergeStructs(getResults(a_trace, a_spikes), ...
				 whole_results), get(a_trace, 'id'));

profile_obj = trace_allspikes_profile(a_trace, a_spikes, whole_spikes_db, ...
				      results_obj, get(a_trace, 'props'));
