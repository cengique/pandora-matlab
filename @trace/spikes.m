function obj = spikes(t, period, plotit)

% spikes - Convert trace to spikes object for spike timing calculations.
%
% Usage:
% obj = spikes(trace, period, plotit)
%
%   Parameters:
%	trace: A trace object.
%	period: A period object denoting the part of trace of interest 
%		(optional).
%	plotit: If non-zero, a plot is generated for showing spikes found
%		(optional).
%
% Description:
%   Creates a spikes object.
%		
% See also: spikes
%
% $Id$
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2004/07/30

if nargin == 0 %# Called with no params
  error('Need trace parameter.');
elseif nargin == 1 
  period = periodWhole(t);
end

if ~ exist('plotit')
  plotit = 0;
end

%# Choose an appropriate spike finder here and indicate in id.
if isfield(t.props, 'spike_finder') & ...
      t.props.spike_finder == 2 & ...
      isfield(t.props, 'threshold')
  [times, peaks, n] = ...
      findspikes(t.data(period.start_time:period.end_time), ...
		 t.props.threshold, plotit);
else %# Assume spike_finder == 1 for filtered method
  [times, peaks, n] = ...
      findFilteredSpikes(t, period, plotit);
end

obj = spikes(times, length(t.data), t.dt, t.id);
