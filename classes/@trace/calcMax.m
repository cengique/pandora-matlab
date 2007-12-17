function [max_val, max_idx] = calcMax(t, a_period)

% calcMax - Calculates the maximal value of the given period 
% 		of the trace, t. 
%
% Usage:
% [max_val, max_idx] = calcMax(t, period)
%
% Description:
%
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
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/07/30

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 % Called with no params
  error('Need trace parameter.');
elseif nargin == 1 
  a_period = periodWhole(t);
end

[max_val, max_idx] = max(t.data(a_period.start_time:a_period.end_time));
