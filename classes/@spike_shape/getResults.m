function [results, a_plot] = getResults(s, plotit)

% getResults - Runs all tests defined by this class and return them in a 
%		structure.
%
% Usage:
% [results, a_plot] = getResults(s, plotit)
%
% Description:
%
%   Parameters:
%	s: A spike_shape object.
%	plotit: If non-zero, plot a graph annotating the test results 
%		(optional).
%
%   Returns:
%	results: A structure associating test names to values in ms and mV.
%	a_plot: plot_abstract, if requested.
%
% See also: spike_shape
%
% $Id$
%
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2004/08/02
%   Based on @spike_trace/shapestats by Jeremy Edgerton.

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('plotit')
  plotit = 0;
end

% convert all to ms/mV
ms_factor = 1e3 * s.trace.dt;
mV_factor = 1e3 * s.trace.dy;

% set defaults to NaN for all available measures
results.MinVm = NaN;
results.PeakVm = NaN;
results.InitVm = NaN;
results.InitVmBySlope = NaN;
results.MaxVmSlope = NaN;
results.HalfVm = NaN;
results.Amplitude = NaN;
results.MaxAHP = NaN;
results.DAHPMag = NaN;
results.InitTime = NaN;
results.RiseTime = NaN;
results.FallTime = NaN;
results.MinTime = NaN;
results.BaseWidth = NaN;
results.HalfWidth = NaN;

% Check for empty spike_shape object first.
if isempty(s.trace.data) 
  a_plot = plot_simple;
  return;
end

% Run tests
[max_val, max_idx] = calcMaxVm(s);

% Sanity check for peak
if max_idx == 1 || max_idx == length(s.trace.data) || ...
      max_idx < 1e-3 / s.trace.dt || ... % less than  some ms on the left side
  ... % less than some ms on the right 
  ( length(s.trace.data) - max_idx ) < 1e-3 / s.trace.dt 
  
  error('spike_shape:not_a_spike', 'Peak at beginning or end of %s! Not a spike.', ...
	get(s, 'id'));
end

[min_val, min_idx] = calcMinVm(s, max_idx);

[init_val, init_idx, rise_time, amplitude, ...
 peak_mag, peak_idx, max_d1o, a_plot] = calcInitVm(s, max_idx, min_idx, plotit);

s_props = get(s, 'props');

% Calculate secondary threshold point based on interpolated slope threshold crossing
try 
  [init_st_idx] = ...
      calcInitVmSlopeThresholdSupsample(s, max_idx, min_idx, s_props.init_threshold, 0);
  init_st_val = interpValByIndex(init_st_idx, s.trace.data);
catch 
  err = lasterror;
  if strcmp(err.identifier, 'calcInitVm:failed')
    init_st_val = NaN;
  else
    rethrow(err);
  end
end

% Sanity check for amplitude
if  (max_val - init_val) * mV_factor < 10 
  error('spike_shape:not_a_spike', '%s not a spike! Too short.', get(s, 'id'));
end

[base_width, half_width, half_Vm, fall_time, min_idx, min_val, ...
 max_ahp, ahp_decay_constant, dahp_mag, dahp_idx] = ...
      calcWidthFall(s, peak_idx, peak_mag, init_idx, init_val);

% Sanity check for amplitude (2)
if (max_val - min_val) * mV_factor < 10
  error('spike_shape:not_a_spike', '%s not a spike! Too short.', get(s, 'id'));
end

% If you change any of the following names, 
% make sure to change the above NaN names, too.
results.MinVm = min_val * mV_factor;
results.PeakVm = peak_mag * mV_factor;
results.InitVm = init_val * mV_factor;
results.InitVmBySlope = init_st_val * mV_factor;
results.MaxVmSlope = max_d1o * mV_factor;
results.HalfVm = half_Vm * mV_factor;
results.Amplitude = amplitude * mV_factor;
results.MaxAHP = max_ahp * mV_factor;
results.DAHPMag = dahp_mag * mV_factor;

results.InitTime = init_idx * ms_factor;
results.RiseTime = rise_time * ms_factor;
results.FallTime = fall_time * ms_factor;
results.MinTime = min_idx * ms_factor;
% Not a realistic measure
%results.ahp_decay_constant = ahp_decay_constant * ms_factor;
results.BaseWidth = base_width * ms_factor;
results.HalfWidth = half_width * ms_factor;

