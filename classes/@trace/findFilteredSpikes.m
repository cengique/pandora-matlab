function [times, peaks, n] = ...
      findFilteredSpikes(t, a_period, plotit, minamp)

% findFilteredSpikes - Runs a frequency filter over the data and then finds all peaks using findspikes.
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
% - minamp parameter added, Jeremy R. Edgerton 2005/10/10
% - custom filter added, Thomas D. Sangrey 2007/12/04

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

s = load('spike_filter_50_3000Hz_ChebII.mat');
fields = fieldnames(s);
fd = getfield(s, fields{1});	% Assuming there's only one element
dn_threshold = -2;

% Scale to mV for spike finder
mV_factor = 1e3 * t.dy;

% sanity check
if size(t.data, 2) > size(t.data, 1)
  error('trace data must be a column vector!');
end

% Append and prepend some activity for filter distortion
prepend_msec = 20;
prepend_size = floor(prepend_msec * 1e-3 / t.dt);
period_len = a_period.end_time - a_period.start_time;
try
  data = [t.data(a_period.start_time:...
                 min(a_period.start_time + prepend_size - 2, a_period.end_time)); ...
	  t.data(a_period.start_time:a_period.end_time) ; ...
	  t.data(max(a_period.end_time - prepend_size - 1, a_period.start_time):...
                 a_period.end_time)] * mV_factor;
catch
  err = lasterror;
  if strcmp(err.identifier, 'MATLAB:exceedsdims')
    error(['Buffer prepend before filtering failed due to trace size. '...
	   'Period of interest in the trace must at least be ' prepend_msec ' msec.']);
  else
    rethrow(err);
  end
end

% Insertion of switch to determine which filter to use - TDS
% CustomFilter props determine new filtfilt operation
if(isfield(t.props, 'butterWorth'))
  butterWorth = t.props.butterWorth;
  b = butterWorth.highPass.b;
  a = butterWorth.highPass.a;
  filtered = filtfilt(b,a,data);
  b = butterWorth.lowPass.b;
  a = butterWorth.lowPass.a;
  filtered=filtfilt(b,a,filtered);
else
  if t.dt ~= 1e-4
    error(['Trace is not sampled at 10KHz, cannot use findFilteredSpikes! ' ...
           'Choose another spike_finder method or supply a CustomFilter ' ...
           '(see trace)']);
  end
  filtered = filtfilt(fd.tf.num, fd.tf.den, data);
end

if ~ exist('minamp', 'var') || isempty(minamp)
  if(max(filtered)>15)
    % up_threshold is 2/3 max amplitude of band-passed data
    up_threshold = max(filtered) * 0.66; 
  else
    up_threshold = 15;                  % default threshold - TDS
  end
else
  up_threshold = minamp;
end

% ignore the added parts
filtered = filtered(prepend_size:(end - prepend_size));
data = data(prepend_size:(end - prepend_size));

% run findspikes by passing 1KHz sampling rate to get results in dt
[times, peaks, n] = findspikes(filtered, 1, up_threshold);

if plotit ~= 0
  figure;
  plot(filtered,  'k'), hold on
  plot([0 length(filtered)], [up_threshold, up_threshold], 'b');
  plot(times, peaks, 'ro');
  title([ t.id ': spikes on filtered data']);
end

newtimes = [];
newpeaks = [];
newn = 0;
% Eliminate non-spike bumps
lasttime = -3e-3 / t.dt;
for k=1:n

  % correct the peak by finding the absolute max within +/- 3ms
  pm = 3e-3 / t.dt;
  [m peak_time] = ...
      max(filtered(max(1, times(k) - pm) : min(times(k) + pm, length(filtered))));
  old_time = times(k);
  times(k) = max(1, times(k) - pm) + peak_time - 1;

  % Only if there's no trough between the old and new maxs
  if min(filtered(min(old_time, times(k)):max(old_time, times(k)))) < ...
	up_threshold
    %then go back
    times(k) = old_time;
  end

  % There should be a trough within 3ms before and within 15ms after the peak
  period_before = floor(3e-3 / t.dt);
  period_after = floor(15e-3 / t.dt);
  min1 = min(filtered(max(1, times(k) - period_before) : times(k)));
  min2 = min(filtered(times(k) : min(times(k) + period_after, length(filtered))));

  % Spike shape criterion test
  if min1 <= up_threshold & min2 <= dn_threshold    

    % Re-correct according to peaks in real data (filtered data is shifted)
    real_pm = 1e-3 / t.dt;
    real_time = times(k);
    [real_peak peak_time] = ...
	max(data(max(1, real_time - real_pm) : ...
		 min(real_time + real_pm, length(data))));
    real_time = max(1, real_time - real_pm) + peak_time - 1;

    % Check again if new time is very close to last time
    if real_time < (lasttime + 2e-3 / t.dt)
      if plotit ~= 0 & plotit ~= 2
  	disp(sprintf('Skip real %f from filtered %f, orig %f', ...
  		     real_time, times(k), old_time));
     end
      continue;
    end

    % Collect in new list
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

% correct the times
times = newtimes + a_period.start_time - 1;
peaks = newpeaks;
n = newn;

if plotit ~= 0
  figure;
  plot(t.data,  'k'), hold on
  %plot(peaks, 'b');
  plot(times, peaks, 'ro');
  title([ t.id ': spikes on original data']);
end
