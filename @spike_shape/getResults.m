function results = getResults(s, plotit)

% getResults - Runs all tests defined by this class and return them in a 
%		structure.
%
% Usage:
% results = getResults(s)
%
% Description:
%   Parameters:
%	s: A spike_shape object.
%	plotit: If non-zero, plot a graph annotating the test results 
%		(optional).
%
%   Returns:
%	results: A structure associating test names to values in ms and mV.
%
% See also: spike_shape
%
% $Id$
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2004/08/02
%   Based on @spike_trace/shapestats by Jeremy Edgerton.

if ~ exist('plotit')
  plotit = 0;
end

%# Check for empty spike_shape object first.
if isempty(s.trace.data) 
  results.MinVm = NaN;
  results.PeakVm = NaN;
  results.InitVm = NaN;
  results.Amplitude = NaN;
  results.MaxAHP = NaN;
  results.DAHPMag = NaN;
  results.RiseTime = NaN;
  results.FallTime = NaN;
  results.BaseWidth = NaN;
  results.HalfWidth = NaN;
  return;
end

%# Run tests
[max_val, max_idx] = calcMaxVm(s);
[min_val, min_idx] = calcMinVm(s, max_idx);
[init_val, init_idx, rise_time, amplitude, ...
 max_ahp, ahp_decay_constant, dahp_mag, dahp_idx, ...
 peak_mag, peak_idx]=calcInitVm(s, max_idx, min_idx, plotit);
[base_width, half_width, half_Vm, fall_time] = ...
      calcWidthFall(s, peak_idx, peak_mag, min_idx, init_idx);

%# convert all to ms/mV
ms_factor = 1e3 * s.trace.dt;
mV_factor = 1e3 * s.trace.dy;

%# plot 'em
if plotit == 1
  %# TODO: Legend?
  plot(s);
  hold on;
  plot(peak_idx * ms_factor, peak_mag * mV_factor, 'r*');
  plot(init_idx * ms_factor, init_val * mV_factor, 'r*');
  plot([init_idx, init_idx + base_width] * ms_factor, ...
       [init_val, init_val] * mV_factor, 'r');

  approx_half_idx = ...
      init_idx + ...
      (half_Vm - init_val) * (peak_idx - init_idx) / (peak_mag - init_val);
  plot([approx_half_idx, approx_half_idx + half_width] * ms_factor, ...
       [half_Vm, half_Vm] * mV_factor, 'r');

  plot([peak_idx, peak_idx] * ms_factor, ...
       [peak_mag, peak_mag - amplitude] * mV_factor, 'r');

  plot(min_idx * ms_factor, min_val * mV_factor, 'r*');
  plot([min_idx, min_idx] * ms_factor, ...
       [min_val, min_val + max_ahp] * mV_factor, 'r');
  plot([min_idx, min_idx + ahp_decay_constant] * ms_factor, ...
       [min_val, min_val] * mV_factor, 'r');

  if ~isnan(dahp_mag)
    plot([dahp_idx, dahp_idx] * ms_factor, ...
	 [min_val, min_val - dahp_mag] * mV_factor, 'r');
  end

  hold off;
end

%# If you change any of the following names, 
%# make sure to change the above NaN names, too.
results.MinVm = min_val * mV_factor;
results.PeakVm = peak_mag * mV_factor;
results.InitVm = init_val * mV_factor;
results.Amplitude = amplitude * mV_factor;
results.MaxAHP = max_ahp * mV_factor;
results.DAHPMag = dahp_mag * mV_factor;

results.RiseTime = rise_time * ms_factor;
results.FallTime = fall_time * ms_factor;
%# Not a realistic measure
%#results.ahp_decay_constant = ahp_decay_constant * ms_factor;
results.BaseWidth = base_width * ms_factor;
results.HalfWidth = half_width * ms_factor;

