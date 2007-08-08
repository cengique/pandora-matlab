function [times, peaks, n] = ...
      findFilteredSpikes(t, a_period, plotit, minamp)

% findFilteredSpikes - Runs a frequency filter over the data and then 
%			finds all peaks using findspikes.
%
% Usage:
% [times, peaks, n] = 
%	findFilteredSpikes(t, a_period, plotit, minamp)
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
%		a_period: Period of interest.
%		plotit: Plots the spikes found if 1.
%		minamp (optional): minimum amplitude above baseline that must be reached.
%			--> adjust as necessary to discriminate spikes from EPSPs.
%	Returns:
%		times: The times of spikes [dt].
%		peaks: The peaks corresponding to the times of spikes.
%		n: The number of spikes.
%
% See also: findspikes, period
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/03/08
% Modified:
% - Adapted to the trace object, CG 2004/07/30
% - minamp parameter added, JRE 2005/10/10

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

if nargin < 4
	up_threshold = 10;	% default.
else
	up_threshold = minamp;
end

s = load('spike_filter_50_3000Hz_ChebII.mat');
fields = fieldnames(s);
fd = getfield(s, fields{1});	%# Assuming there's only one element
dn_threshold = -2;

%# Scale to mV for spike finder
mV_factor = 1e3 * t.dy;

%# Append and prepend some activity for filter distortion
prepend_msec = 20;
prepend_size = floor(prepend_msec * 1e-3 / t.dt);
try
  data = [t.data(a_period.start_time:(a_period.start_time + prepend_size - 2)); ...
	  t.data(a_period.start_time:a_period.end_time) ; ...
	  t.data((a_period.end_time - prepend_size + 1):a_period.end_time)] * mV_factor;
catch
  err = lasterror;
  if strcmp(err.identifier, 'MATLAB:exceedsdims')
    error(['Buffer prepend before filtering failed due to trace size. '...
	   'Period of interest in the trace must at least be ' prepend_msec ' msec.']);
  else
    rethrow(err);
  end
end

filtered = filtfilt(fd.tf.num, fd.tf.den, data);

%# ignore the added parts
filtered = filtered(prepend_size:(end - prepend_size));
data = data(prepend_size:(end - prepend_size));
[times, peaks, n] = findspikes(filtered, 1, up_threshold);

newtimes = [];
newpeaks = [];
newn = 0;
%# Eliminate non-spike bumps
lasttime = -3e-3 / t.dt;
for k=1:n

  %# correct the peak by finding the absolute max within +/- 3ms
  pm = 3e-3 / t.dt;
  [m peak_time] = ...
      max(filtered(max(1, times(k) - pm) : min(times(k) + pm, length(filtered))));
  old_time = times(k);
  times(k) = max(1, times(k) - pm) + peak_time - 1;

  %# Only if there's no trough between the old and new maxs
  if min(filtered(min(old_time, times(k)):max(old_time, times(k)))) < ...
	up_threshold
    %#then go back
    times(k) = old_time;
  end

  %# There should be a trough within 3ms before and within 15ms after the peak
  period_before = floor(3e-3 / t.dt);
  period_after = floor(15e-3 / t.dt);
  min1 = min(filtered(max(1, times(k) - period_before) : times(k)));
  min2 = min(filtered(times(k) : min(times(k) + period_after, length(filtered))));

  %# Spike shape criterion test
  if min1 <= up_threshold & min2 <= dn_threshold    

    %# Re-correct according to peaks in real data (filtered data is shifted)
    real_pm = 1e-3 / t.dt;
    real_time = times(k);
    [real_peak peak_time] = ...
	max(data(max(1, real_time - real_pm) : ...
		 min(real_time + real_pm, length(data))));
    real_time = max(1, real_time - real_pm) + peak_time - 1;

    %# Check again if new time is very close to last time
    if real_time < (lasttime + 2e-3 / t.dt)
      if plotit ~= 0 & plotit ~= 2
  	disp(sprintf('Skip real %f from filtered %f, orig %f', ...
  		     real_time, times(k), old_time));
     end
      continue;
    end

    %# Collect in new list
    newtimes = [newtimes, real_time];
    newpeaks = [newpeaks, real_peak];
    newn = newn + 1;
    lasttime = real_time;

    if plotit ~= 0 & plotit ~= 2
      disp(sprintf('Add real %f from filtered %f, orig %f', ...
		   real_time, times(k), old_time));
    end

  else
    if plotit ~= 0 & plotit ~= 2
      disp(sprintf('Failed criterion for %f, orig %f (min1=%f, min2=%f)', ...
		   times(k), old_time, min1, min2));
    end    
  end
end

%# correct the times
times = newtimes + a_period.start_time - 1;
peaks = newpeaks;
n = newn;
