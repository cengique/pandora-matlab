function [times, peaks, n] = ...
      findFilteredSpikes(t, period, plotit)

% findFilteredSpikes - Runs a frequency filter over the data and then 
%			finds all peaks using findspikes.
%
% Usage:
% [times, peaks, n] = 
%	findFilteredSpikes(t, period, plotit)
%
% Description:
%   Runs a 50-300 Hz band-pass filter over the data and then calls findspikes.
%   The filter both removes low-frequency offset changes, such as 
%   cip period effects, and high-frequency noise that is detected 
%   as local peaks by findspikes. The spikes found are 
%   post-processed to make sure the rise and fall times are consistent.
%   Note: The filter employed only works with data sampled at 10kHz.
%
% 	Parameters: 
%		t: Trace object
%		period: Period of interest.
%		plotit: Plots the spikes found if 1.
%	Returns:
%		times: The times of spikes [dt].
%		peaks: The peaks corresponding to the times of spikes.
%		n: The number of spikes.
%
% See also: findspikes, period
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/03/08
% Modified:
% - Adapted to the trace object, CG 2004/07/30

s = load('spike_filter_50_300Hz_ChebII.mat');
fields = fieldnames(s);
fd = getfield(s, fields{1});	%# Assuming there's only one element
up_threshold = 10;
dn_threshold = -2;

%# Prepend some activity for filter distortion
prepend_size = 20e-3 / t.dt;
data = [t.data(period.start_time:floor(period.start_time + prepend_size)); ...
	t.data(period.start_time:period.end_time) ];

filtered = filtfilt(fd.tf.num, fd.tf.den, data);

%# ignore the prepended part
filtered = filtered(floor(prepend_size):end);
[times, peaks, n] = findspikes(filtered, up_threshold, plotit);

newtimes = [];
newpeaks = [];
newn = 0;
%# Eliminate non-spike bumps
lasttime = -3e-3 / t.dt;
for i=1:n

  if times(i) < (lasttime + 3e-3 / t.dt)
    if plotit ~= 0 & plotit ~= 2
      disp(sprintf('Skip %f', times(i)));
    end
    continue;
  end

  %# correct the peak by finding the absolute max within +/- 3ms
  pm = 3e-3 / t.dt;
  [m peak_time] = ...
      max(filtered(max(1, times(i) - pm) : min(times(i) + pm, length(filtered))));
  times(i) = max(1, times(i) - pm) + peak_time - 1;

  %# There should be a trough within 3ms before and within 5ms after the peak
  min1 = min(filtered(max(1, times(i) - 3e-3 / t.dt) : times(i)));
  min2 = min(filtered(times(i) : min(times(i) + 5e-3 / t.dt, length(filtered))));

  if min1 <= up_threshold & ...
	min2 <= dn_threshold    
    newtimes = [newtimes, times(i)];
    newpeaks = [newpeaks, peaks(i)];
    newn = newn + 1;
    lasttime = times(i);
  else
    if plotit ~= 0 & plotit ~= 2
      disp(sprintf('Failed criterion for %f', times(i)));
    end    
  end
end

%# correct the times
times = newtimes + period.start_time;
peaks = newpeaks;
n = newn;
