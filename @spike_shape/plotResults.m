function a_plot = plotResults(s)

% plotResults - Plots the spike shape annotated with result characteristics.
%
% Usage:
% a_plot = plotResults(s)
%
% Description:
%   Parameters:
%	s: A spike_shape object.
%
%   Returns:
%	a_plot: A plot_abstract object that can be visualized.
%
% See also: spike_shape, plot_abstract
%
% $Id$
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2004/11/17

results = getResults(s);

init_idx = results.InitTime ;
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
min_idx = results.MinTime ;
%# Not a realistic measure
%#results.ahp_decay_constant = ahp_decay_constant ;
base_width = results.BaseWidth ;
half_width = results.HalfWidth ;

%# TODO: Legend?
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
	     min_idx , min_val , 'r*', ...
	     [min_idx, min_idx] , ...
	     [min_val, min_val + max_ahp] , 'r', ...
	     %#[min_idx, min_idx + ahp_decay_constant] , ...
	     %#[min_val, min_val] , 'r' 
	     };

if ~isnan(dahp_mag)
  plot_data = { plot_data{:}, [min_idx+5, min_idx+5] , ...
	       [min_val, min_val - dahp_mag] , 'r'};
end

%# Get regular spike shape plot first
spsh_plot = plotData(s);

%# Create annotation plot using the above as template
annot_plot = set(spsh_plot, 'data', plot_data);
annot_plot = set(annot_plot, 'legend', {});

%# Superpose them
a_plot = superposePlots([spsh_plot, annot_plot]);
