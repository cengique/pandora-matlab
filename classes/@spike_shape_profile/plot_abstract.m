function a_plot = plot_abstract(s, props)

% plot_abstract - Plots the spike shape with measurements marked in red.
%
% Usage:
% a_plot = plot_abstract(s, props)
%
% Description:
%
%   Parameters:
%	s: A spike_shape object.
%	props: A structure with any optional properties.
%		absolute_peak_time: Shift the peak to this point on the plot.
%		no_plot_spike: Do not plot the spike shape first.
%
%   Returns:
%	a_plot: A plot_abstract object that can be visualized.
%
% See also: spike_shape, plot_abstract
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/08/17

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props')
  props = struct([]);
end

results = getResults(s);

if isfield(props, 'absolute_peak_time')
  absolute_peak_shift = props.absolute_peak_time - (results.InitTime + results.RiseTime);
else
  absolute_peak_shift = 0;
end

init_idx = results.InitTime + absolute_peak_shift;
rise_time = results.RiseTime ;
peak_time = init_idx + rise_time;
peak_mag = results.PeakVm;
min_val = results.MinVm;
init_val = results.InitVm ;
half_Vm = results.HalfVm;
amplitude = results.Amplitude ;
max_ahp = results.MaxAHP ;
dahp_mag = results.DAHPMag ;
fall_time = results.FallTime ;
min_idx = results.MinTime + absolute_peak_shift;
% Not a realistic measure
%results.ahp_decay_constant = ahp_decay_constant ;
base_width = results.BaseWidth ;
half_width = results.HalfWidth ;

% TODO: Legend?
approx_half_idx = ...
    init_idx + ...
    (half_Vm - init_val) * (peak_time - init_idx) / (peak_mag - init_val);

plot_data = {peak_time, peak_mag , 'r*', ...
	     init_idx, init_val , 'r*', ...
	     [init_idx, init_idx + base_width] , [init_val, init_val] , 'r', ...
	     [approx_half_idx, approx_half_idx + half_width] , ...
	     [half_Vm, half_Vm] , 'r', ...
	     [peak_time, peak_time] , ...
	     [peak_mag, peak_mag - amplitude] , 'r', ...
	     min_idx , min_val , 'm*', ...
	     [min_idx, min_idx] , ...
	     [min_val, min_val + max_ahp] , 'r', ...
	     %[min_idx, min_idx + ahp_decay_constant] , ...
	     %[min_val, min_val] , 'r' 
	     };

if ~isnan(dahp_mag)
  plot_data = { plot_data{:}, [min_idx+5, min_idx+5] , ...
	       [min_val, min_val - dahp_mag] , 'r'};
end

% Get regular spike shape plot first
spsh_plot = plotData(s.spike_shape);

% Create annotation plot using the above as template
annot_plot = set(spsh_plot, 'data', plot_data);
annot_plot = set(annot_plot, 'legend', {});

% Unless not wanted to plot
if ~isfield(props, 'no_plot_spike')
  % Superpose them
  a_plot = superposePlots([spsh_plot, annot_plot]);
else 
  a_plot = annot_plot;
end
