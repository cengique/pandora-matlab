function isi = getISIs(s, a_period)

% getISIs - Calculates the firing rate of the spikes found in the given 
%		period with an averaged inter-spike-interval approach.
%
% Usage:
% isi = getISIs(s, period)
%
% Description:
%   Parameters:
%	s: A spikes object.
%	period: The period where spikes were found (optional)
%
%   Returns:
%	isi: Inter-spike-interval vector [dt]
%
% See also: trace, spikes, period
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/03/09
% Modified:
% - Adapted to the spikes object, CG 2004/07/31

%# By default apply to the whole of s
if exist('a_period')
  s = withinPeriod(s, a_period);
end

isi = diff(s.times);

