function results = getResults(a_cip_trace, a_spikes)

% getResults - Calculate test results given a_spikes object.
%
% Usage:
% results = getResults(a_cip_trace, a_spikes)
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
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/14

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

results = mergeStructs(getRateResults(a_cip_trace, a_spikes), ...
		       getCIPResults(a_cip_trace, a_spikes), getBurstResults(a_cip_trace, a_spikes));
