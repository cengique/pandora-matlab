function avg_val = calcRecSpontPotAvg(t)

% calcRecSpontPotAvg - Calculates the average potential value of the 
%			recovery period of the cip_trace, t. 
%
% Usage:
% avg_val = calcRecSpontPotAvg(t)
%
% Description:
%   Parameters:
%	t: A cip_trace object.
%
%   Returns:
%	avg_val: The avg value [dy].
%
% See also: period, trace, trace/calcAvg
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/25

avg_val = calcAvg(t.trace, periodRecSpont(t));

