function the_period = periodIniSpont(t)

% periodIniSpont - Returns the initial spontaneous activity period of 
%		cip_trace, t. 
%
% Usage:
% the_period = periodIniSpont(t)
%
% Description:
%
%   Parameters:
%	t: A trace object.
%
%   Returns:
%	the_period: A period object.
%
% See also: period, cip_trace, trace
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/25

time_start = 1;
the_period = period(time_start, t.pulse_time_start - 1);
