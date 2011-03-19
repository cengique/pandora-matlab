function results = getResults(a_trace, a_spikes)

% getResults - Runs all tests defined by this class and return them in a 
%		structure.
%
% Usage:
% results = getResults(a_trace)
%
% Description:
%
%   Parameters:
%	t: A trace object.
%
%   Returns:
%	results: A structure associating test names to values 
%		in ms and mV (or mA).
%
% See also: spike_shape
%
% $Id$
%
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2004/09/13
%   Vladislav Sekulic <vlad.sekulic@utoronto.ca>, 2011/03/19

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

results = mergeStructs(getRateResults(a_trace, a_spikes), ...
		       getPotResults(a_trace));
