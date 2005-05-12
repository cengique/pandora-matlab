function obj = spikes(t, plotit)

% spikes - Convert cip_trace to spikes object for spike timing calculations.
%
% Usage:
% obj = spikes(trace, plotit)
%
%   Parameters:
%	trace: A trace object.
%	plotit: If non-zero, a plot is generated for showing spikes found
%		(optional).
%
% Description:
%   Creates a spikes object by finding the spikes in the three 
% separate periods, initial spontaneous activity period, CIP period, and
% final recovery period.
%		
% See also: spikes, period
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/25

if nargin == 0 %# Called with no params
  error('Need trace parameter.');
end

if ~ exist('plotit')
  plotit = 0;
end

%# Allow some tolerance for spike finding and then cur them off
tolerance = 5e-3 / get(t, 'dt');
ini_period = periodIniSpont(t);
ini_period = set(ini_period, 'end_time', ini_period.end_time + tolerance);
ini_spikes = withinPeriodWOffset(spikes(t.trace, ini_period, plotit), ...
				 periodIniSpont(t));

cip_period = periodPulse(t);
cip_period = set(cip_period, 'start_time', cip_period.start_time - tolerance);
cip_period = set(cip_period, 'end_time', cip_period.end_time + tolerance);
cip_spikes = withinPeriodWOffset(spikes(t.trace, cip_period, plotit), ...
				 periodPulse(t));

rec_period = periodRecSpont(t);
rec_period = set(rec_period, 'start_time', rec_period.start_time - tolerance);
rec_spikes = withinPeriodWOffset(spikes(t.trace, rec_period, plotit), ...
				 periodRecSpont(t));

obj = spikes([ini_spikes.times, cip_spikes.times, rec_spikes.times], ...
	     length(t.trace.data), t.trace.dt, t.trace.id);

