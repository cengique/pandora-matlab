function cv = ISICV(s, a_period)

% ISICV - Calculates the coefficient of variation (CV) of the 
%	inter-spike-intervals (ISI).
%
% Usage:
% cv = ISICV(s, a_period)
%
% Description:
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
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/13

ISIs = getISIs(s, a_period);

if length(ISIs) ~= 0
  cv = std(ISIs) / mean(ISIs); 
else
  cv = NaN;
end

