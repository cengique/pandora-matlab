function [min_val, min_idx] = calcMin(t, period)

% calcMin - Calculates the minimal value of the given period 
% 		of the trace, t. 
%
% Usage:
% [min_val, min_idx] = calcMin(t, period)
%
% Description:
%   Parameters:
%	t: A trace object.
%	period: A period object (optional).
%
%   Returns:
%	min_val: The min value.
%	min_idx: Its index in the trace.
%
% See also: period, trace
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/07/30

if nargin == 0 %# Called with no params
  error('Need trace parameter.');
elseif nargin == 1 
  period = periodWhole(t);
end

[min_val, min_idx] = min(t.data(period.start_time:period.end_time));
