function results = getRateResults(a_trace, a_spikes)

% getRateResults - Calculate test results related to spike rate for the
%		   whole spike period.
%
% Usage:
% results = getRateResults(a_trace, a_spikes)
%
% Description:
%
%   Parameters:
%	a_trace: A trace object.
%	a_spikes: A spikes object.
%
%   Returns:
%	results: A structure associating test names with result values.
%
% See also: trace, spikes, spike_shape
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/30
% 	  Vladislav Sekulic <vlad.sekulic@utoronto.ca>, 2011/03/19

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Whole periods only
results.SpikeRate = ...
    spikeRate(a_spikes, periodWhole(a_trace));
results.SpikeRateISI = ...
    spikeRateISI(a_spikes, periodWhole(a_trace));

% ISI-CV 
results.ISICV = ISICV(a_spikes, periodWhole(a_trace));
