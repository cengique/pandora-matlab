function obj = getRecSpontSpike(t, s, spike_num, props)

% getRecSpontSpike - Convert a spike in the CIP period to a spike_shape object.
%
% Usage:
% obj = getRecSpontSpike(trace, spikes, spike_num, props)
%
%   Parameters:
%	trace: A trace object.
%	spikes: A spikes object on trace.
%	spike_num: The index of spike to extract.
%
% Description:
%   Creates a spike_shape object from desired spike.
%		
% See also: spike_shape
%
% $Id$
%
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2005/05/08

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

props.spike_id = 'pulse';
obj = getSpike(withinPeriod(t, periodRecSpont(t)), ...
	       withinPeriod(s, periodRecSpont(t)), ...
	       spike_num, props)
