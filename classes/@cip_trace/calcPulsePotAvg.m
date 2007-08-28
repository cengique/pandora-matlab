function avg_val = calcPulsePotAvg(t)

% calcPulsePotAvg - Calculates the average potential value of the 
%		CIP period of the cip_trace, t. 
%
% Usage:
% avg_val = calcPulsePotAvg(t)
%
% Description:
%
%   Parameters:
%	t: A cip_trace object.
%
%   Returns:
%	avg_val: The avg value [dy].
%
% See also: period, trace, trace/calcAvg
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/25

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

avg_val = calcAvg(t.trace, periodPulse(t));

