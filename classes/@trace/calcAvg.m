function avg_val = calcAvg(t, a_period)

% calcAvg - Calculates the average value of the given period 
% 		of the trace, t. 
%
% Usage:
% avg_val = calcAvg(t, period)
%
% Description:
%
%   Parameters:
%	t: A trace object.
%	period: A period object (optional).
%
% See also: period, trace
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/07/30

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 %# Called with no params
  error('Need trace parameter.');
elseif nargin == 1 
  a_period = periodWhole(t);
end

if (a_period.end_time - a_period.start_time) >= 0
  avg_val = mean(t.data(a_period.start_time:a_period.end_time));
else
  avg_val = NaN;
end