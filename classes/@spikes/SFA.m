function sfa = SFA(s, a_period)

% SFA - Calculates the spike frequency accommodation (SFA) of the 
%	inter-spike-intervals (ISI).
%
% Usage:
% sfa = SFA(s, a_period)
%
% Parameters:
%	s: A spikes object.
%	a_period: The period where spikes were found (optional)
%
% Description:
% SFA is the ration of the last ISI to the first ISI in the period.
%
% Returns:
%	sfa: Spike frequency accommodation.
%
% See also: spikes, period
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/13

ISIs = getISIs(s, a_period);

if length(ISIs) > 1
  sfa = ISIs(end) / ISIs(1); 
else
  sfa = NaN;
end

