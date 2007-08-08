function cv = ISICV(s, a_period)

% ISICV - Calculates the coefficient of variation (CV) of the 
%	inter-spike-intervals (ISI).
%
% Usage:
% cv = ISICV(s, a_period)
%
% Description:
%
%   Parameters:
%	s: A spikes object.
%	a_period: The period where spikes were found (optional)
%
%   Returns:
%	cv: Coefficient of variation.
%
% See also: spikes, period
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/13

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

ISIs = getISIs(s, a_period);

if length(ISIs) ~= 0
  cv = std(ISIs) / mean(ISIs); 
else
  cv = NaN;
end

