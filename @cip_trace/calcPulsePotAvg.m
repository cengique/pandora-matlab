function avg_val = calcPulsePotAvg(t)

% calcPulsePotAvg - Calculates the average potential value of the 
%		CIP period of the cip_trace, t. 
%
% Usage:
% avg_val = calcPulsePotAvg(t)
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

avg_val = calcAvg(t.trace, periodPulse(t));

