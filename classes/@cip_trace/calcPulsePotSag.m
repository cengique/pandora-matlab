function [min_val, min_idx, sag_val] = calcPulsePotSag(t)

% calcPulsePotSag - Calculates the minimal sag and sag amount of the CIP period of the cip_trace, t. 
%
% Usage:
% [min_val, min_idx, sag_val] = calcPulsePotSag(t)
%
% Description:
%   The minimal sag is the minimal potential value of the 
% first half of the CIP period. The sag amount is calculated by 
% comparing this to the steady-state value at the end of the CIP period.
%
%   Parameters:
%	t: A cip_trace object.
%
%   Returns:
%	min_val: The min value [dy].
%	min_idx: The index of the min value [dt].
%	sag_val: The sag amount [dy].
%
% See also: period, trace, trace/calcMin
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/25

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Minimum of the first half of the CIP period
[min_val, min_idx] = calcMin(t.trace, periodPulseHalf1(t));

steady_val = calcAvg(t.trace, periodPulseIni50msRest2(t));
sag_val = steady_val - min_val;

if (sag_val < 0)
  warning('Negative sag! Make sure there''re no spikes in CIP period.');
  sag_val = NaN;
end
