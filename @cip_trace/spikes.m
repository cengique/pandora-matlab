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

ini_spikes = spikes(t.trace, periodIniSpont(t), plotit);
cip_spikes = spikes(t.trace, periodPulse(t), plotit);
rec_spikes = spikes(t.trace, periodRecSpont(t), plotit);

obj = ([ini_spikes.times, cip_spikes.times, rec_spikes.times], ...
       length(t.trace.data), t.dt, t.id);

