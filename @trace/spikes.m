function obj = spikes(t, a_period, plotit)

% spikes - Convert trace to spikes object for spike timing calculations.
%
% Usage:
% obj = spikes(trace, a_period, plotit)
%
%   Parameters:
%	trace: A trace object.
%	a_period: A period object denoting the part of trace of interest 
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
  a_period = periodWhole(t);
end

if ~ exist('plotit')
  plotit = 0;
end

if (a_period.end_time - a_period.start_time) > 0

%# Choose an appropriate spike finder here and indicate in id.
if isfield(t.props, 'spike_finder') & ...
      t.props.spike_finder == 2 & ...
      isfield(t.props, 'threshold')
  %# Scale to mV for spike finder
  mV_factor = 1e3 * t.dy;

  [times, peaks, n] = ...
      findspikes(t.data(a_period.start_time:a_period.end_time) * mV_factor, ...
		 t.props.threshold, plotit);
else %# Assume spike_finder == 1 for filtered method
  [times, peaks, n] = ...
      findFilteredSpikes(t, a_period, plotit);
end

obj = spikes(times, length(t.data), t.dt, t.id);

else

obj = spikes([], length(t.data), t.dt, t.id);

end