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

%# Run tests
[max_val, max_idx] = calcMaxVm(s);
[min_val, min_idx] = calcMinVm(s, max_idx);
[init_val, init_idx, rise_time, amplitude, ...
 max_ahp, ahp_decay_constant, dahp_mag, dahp_idx, ...
 peak_mag, peak_idx]=calcInitVm(s, max_idx, min_idx);
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

  plot([init_idx, init_idx + half_width] * ms_factor, ...
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


results.min_Vm = min_val * mV_factor;
results.peak_Vm = peak_mag * mV_factor;
results.init_Vm = init_val * mV_factor;
results.amplitude = amplitude * mV_factor;
results.max_ahp = max_ahp * mV_factor;
results.dahp_mag = dahp_mag * mV_factor;

results.rise_time = rise_time * ms_factor;
results.fall_time = fall_time * ms_factor;
%# Not a realistic measure
%#results.ahp_decay_constant = ahp_decay_constant * ms_factor;
results.base_width = base_width * ms_factor;
results.half_width = half_width * ms_factor;

