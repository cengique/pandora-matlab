function [max_val, max_idx] = calcMax(t, period)

% calcMax - Calculates the maximal value of the given period 
% 		of the trace, t. 
%
% Usage:
% [max_val, max_idx] = calcMax(t, period)
%
% Description:
%   Parameters:
%	t: A trace object.
%	period: A period object (optional).
%
%   Returns:
%	max_val: The max value.
%	max_idx: Its index in the trace.
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

[max_val, max_idx] = max(t.data(period.start_time:period.end_time));
