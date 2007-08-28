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
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/25

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 %# Called with no params
  error('Need trace parameter.');
end

if ~ exist('plotit')
  plotit = 0;
end

%# Allow some tolerance for spike finding and then cur them off
tolerance = 5e-3 / get(t, 'dt');
ini_period = periodIniSpont(t);
if get(ini_period, 'end_time') - get(ini_period, 'start_time') > 0
  ini_period = set(ini_period, 'end_time', min(ini_period.end_time + tolerance, ...
					       length(get(t, 'data'))));
  ini_spikes = withinPeriodWOffset(spikes(t.trace, ini_period, plotit), ...
				   periodIniSpont(t));
else
  ini_spikes = spikes;		%# Make empty spikes object
end

cip_period = periodPulse(t);
if get(cip_period, 'end_time') - get(cip_period, 'start_time') > 0
  cip_period = set(cip_period, 'start_time', max(1, cip_period.start_time - tolerance));
  cip_period = set(cip_period, 'end_time', min(cip_period.end_time + tolerance, ...
					       length(get(t, 'data'))));
  cip_spikes = withinPeriodWOffset(spikes(t.trace, cip_period, plotit), ...
				   periodPulse(t));
else
  cip_spikes = spikes;		%# Make empty spikes object
end


rec_period = periodRecSpont(t);
if get(rec_period, 'end_time') - get(rec_period, 'start_time') > 0
  rec_period = set(rec_period, 'start_time', max(1, rec_period.start_time - tolerance));
  rec_spikes = withinPeriodWOffset(spikes(t.trace, rec_period, plotit), ...
				   periodRecSpont(t));
else
  rec_spikes = spikes;		%# Make empty spikes object
end

obj = spikes([ini_spikes.times, cip_spikes.times, rec_spikes.times], ...
	     length(t.trace.data), t.trace.dt, t.trace.id);

