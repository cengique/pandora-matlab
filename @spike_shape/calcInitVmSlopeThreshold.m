function [init_idx, a_plot] = ...
      calcInitVmSlopeThreshold(s, max_idx, min_idx, thr, plotit)

% calcInitVmSlopeThreshold - Calculates the AP threshold using the slope threhold crossing.
%
% Usage:
% [init_idx, a_plot] = calcInitVmSlopeThreshold(s, max_idx, min_idx, thr, plotit)
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
%   Cengiz Gunay <cgunay@emory.edu>, 2004/11/24

if ~ exist('plotit')
  plotit = 0;
end
a_plot = [];

deriv = diffT(s.trace.data(1 : (max_idx + 2)) * s.trace.dy, s.trace.dt);
deriv = deriv(3:(end-2));
%# threshold voltage derivative
idx = find(deriv >= thr); 
if length(idx) == 0 
  %# TODO: give error and catch the error in the above level
  warning('spike_shape:threshold_derivative', ...
	  ['Derivative threshold ' num2str(s.props.init_threshold) ...
	   ' failed to find spike initiation point. ' ...
	   'Taking the fist point in the trace as AP threshold.']);
  idx = 1;
end
init_idx = idx(1) + 2;

if plotit
  class_name = strrep(class(s), '_', ' ');
  t = (3 : max_idx) * s.trace.dt * 1e3;
  t_data = s.trace.data(3 : max_idx);
  a_plot = ...
      plot_abstract({t, deriv/max(abs(deriv)), ...
		     t, t_data/max(abs(t_data)), ...
		     init_idx * s.trace.dt * 1e3, ...
		     s.trace.data(init_idx)/max(abs(t_data)), '*'}, ...
		    {'time [ms]', 'normalized'}, ...
		    [class_name ': ' get(s, 'id') ...
		     ', Slope threshold method, ' ...
		     ' v\prime > ' num2str(thr) ' crossing'], ...
		    {'v\prime', 'v', 'thr'}, 'plot');
end

