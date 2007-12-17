function results = getBurstResults(a_cip_trace, a_spikes)

% getBurstResults - Calculate test results related to Burst behavior.
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
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/30, Tom Sangrey
% 2006/1/23

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Spike rates [Hz] in total spikes over time method for all periods
ms_factor = 1e3 * get(a_cip_trace, 'dt');

% Exponential approximation to amplitude decay for slow inactivating channels
[a_tau, a_inf] = spikeAmpSlope(a_spikes, a_cip_trace, ...
			       periodPulse(a_cip_trace));
results.SlowRD_ISIdecayTime = a_tau;
results.SlowRD_ISIchange = a_inf;

