function avg_val = calcAvg(t, a_period)

% calcAvg - Calculates the average value of the given period 
% 		of the trace, t. 
%
% Usage:
% avg_val = calcAvg(t, period)
%
% Description:
%   Parameters:
%	t: A trace object.
%	period: A period object (optional).
%
% See also: period, trace
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/07/30

if nargin == 0 %# Called with no params
  error('Need trace parameter.');
elseif nargin == 1 
  a_period = periodWhole(t);
end

avg_val = mean(t.data(a_period.start_time:a_period.end_time));
