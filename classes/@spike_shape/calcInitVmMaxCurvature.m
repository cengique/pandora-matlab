function [init_idx, a_plot] = calcInitVmMaxCurvature(s, max_idx, min_idx, plotit)

% calcInitVmMaxCurvature - Calculates the action potential threshold using the
%			maximum of the curvature equation.
%
% Usage:
% [init_idx, a_plot] = calcInitVmMaxCurvature(s, max_idx, min_idx, plotit)
%
% Description:
% Point of maximum curvature: Kp = V''[1 + (V')^2]^(-3/2)
% Taken from Sekerli, Del Negro, Lee and Butera. 
% IEEE Trans. Biomed. Eng., 51(9): 1665-71, 2004.
% 
%   Parameters:
%	s: A spike_shape object.
%	max_idx: The index of the maximal point of the spike_shape [dt].
%	min_idx: The index of the minimal point of the spike_shape [dt].
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
%
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2004/11/19
%   Taken from Sekerli, Del Negro, Lee and Butera. IEEE Trans. Biomed. Eng.,
%	51(9): 1665-71, 2004.

if ~ exist('plotit')
  plotit = 0;
end
a_plot = [];

d2 = diff2T(s.trace.data(1 : (max_idx + 2)) * s.trace.dy, s.trace.dt);
d1 = diffT(s.trace.data(1 : (max_idx + 2)) * s.trace.dy, s.trace.dt);
d2 = d2(3:(end -2));
d1 = d1(3:(end -2));
k1 = 1 + d1 .* d1;
k = d2 ./ sqrt(k1 .* k1 .* k1);
%# Find first local maximum in k before spike peak
dk = diff(k);
dk2 = dk(2:end) .* dk(1:(end-1));
zc = find(dk2 < 0);
if length(zc) == 0 
  warning('spike_shape:curvature_failed', ...
	  ['Failed to find local maximum of curvature near the AP peak. ', ...
	   'Taking the first point in the trace as threshold instead.']);
  %# Then, the first point of the trace is the spike initiation point.
  idx = 1;
else
  %#[val, idx] = max(k); 
  idx = zc(end) + 1; %# need to add 1 because of diff
  idx = idx + 2;
end
if plotit
  class_name = strrep(class(s), '_', ' ');
  t = (3 : max_idx) * s.trace.dt * 1e3;
  t_data = s.trace.data(3 : max_idx);
  a_plot = ...
      plot_abstract({t, d1/max(abs(d1)), t, d2/max(abs(d2)), ...
		     t, k/max(abs(k)), '.-', ...
		     t, t_data/max(abs(t_data)), ...
		     idx * s.trace.dt * 1e3, s.trace.data(idx)/max(abs(t_data)), '*'}, ...
		    {'time [ms]', 'normalized'}, ...
		    [class_name ': ' get(s, 'id') ', Curvature method, ' ...
		     'max of K_p = v\prime\prime[1 + v\prime^2]^{-3/2}' ], ...
		    {'v\prime', 'v\prime\prime', 'K_p', ...
		     'v', 'thr'}, 'plot');
end
init_idx = idx;