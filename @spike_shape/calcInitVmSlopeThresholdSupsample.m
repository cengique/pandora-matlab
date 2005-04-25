function [init_idx, a_plot] = ...
      calcInitVmSlopeThresholdSupsample(s, max_idx, min_idx, thr, plotit)

% calcInitVmSlopeThresholdSupsample - Estimates the AP threshold as the first slope threshold crossing by first supersampling the data using cubic spline interpolation.
%
% Usage:
% [init_idx, a_plot] = calcInitVmSlopeThresholdSupsample(s, max_idx, min_idx, thr, plotit)
%
% Description:
% 
%   Parameters:
%	s: A spike_shape object.
%	max_idx: The index of the maximal point of the spike_shape [dt].
%	min_idx: The index of the minimal point of the spike_shape [dt].
%	thr: Threshold for time derivative of voltage.
%	plotit: If non-zero, plot a graph annotating the test results 
%		(optional).
%
%   Returns:
%	init_idx: AP threshold index in the spike_shape [dt].
%	a_plot: plot_abstract, if requested.
%
% See also: calcInitVm
%
% $Id$
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2005/03/23

if ~ exist('plotit')
  plotit = 0;
end
a_plot = [];

%# Supersampling factor (times as many new data points)
int_fac = 4; 

t_vals = 1 : (max_idx + 2);
int_vals = 1 : int_fac * (max_idx + 2);
interp = spline(t_vals * s.trace.dt, s.trace.data(t_vals) * s.trace.dy, ...
		int_vals * s.trace.dt / int_fac);

deriv = diffT(interp, s.trace.dt / int_fac);
deriv = deriv(3:(end-2));

%# threshold voltage derivative
idx = find(deriv >= thr); 
if length(idx) == 0 
  %# Raise error and catch it in the caller function
  error('calcInitVm:failed', ...
	['Derivative threshold ' num2str(s.props.init_threshold) ...
	 ' failed to find spike initiation point. ' ]);
end

%# Cannot be less than 1
init_idx = max((idx(1) + 2) / int_fac, 1);

if plotit
  class_name = strrep(class(s), '_', ' ');
  t = (3 : max_idx) * s.trace.dt * 1e3;
  t_data = s.trace.data(3 : max_idx);
  threshold_estimate = interp1([floor(init_idx), ceil(init_idx)], ...
		   [s.trace.data(floor(init_idx)), s.trace.data(ceil(init_idx))], ...
		   init_idx);

  a_plot = ...
      plot_abstract({int_vals(3:(end-2)) * s.trace.dt * 1e3 ./ int_fac, ...
		     deriv/max(abs(deriv)), ...
		     t, t_data/max(abs(t_data)), ...
		     init_idx * s.trace.dt * 1e3, threshold_estimate/max(abs(t_data)), '*'}, ...
		    {'time [ms]', 'normalized'}, ...
		    [class_name ': ' get(s, 'id') ...
		     ', Slope threshold method (interp), ' ...
		     ' v\prime > ' num2str(thr) ' crossing'], ...
		    {'v\prime', 'v', 'thr'}, 'plot');
end

