function isi = getISIs(s, a_period)

% getISIs - Calculates the firing rate of the spikes found in the given 
%		period with an averaged inter-spike-interval approach.
%
% Usage:
% isi = getISIs(s, period)
%
% Description:
%
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
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/03/09
% Modified:
% - Adapted to the spikes object, CG 2004/07/31

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% By default apply to the whole of s
if exist('a_period')
  s = withinPeriod(s, a_period);
end

isi = diff(s.times);

