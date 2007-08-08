function [init_idx, a_plot] = ...
      calcInitVmLtdMaxCurv(s, max_idx, min_idx, lo_thr, hi_thr, plotit)

% calcInitVmLtdMaxCurv - Calculates the action potential threshold using the maximum of the curvature equation only in the limited range given with two voltage slope thresholds.
%
% Usage:
% [init_idx, a_plot] = calcInitVmLtdMaxCurv(s, max_idx, min_idx, lo_thr, hi_thr, plotit)
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
%	lo_thr, hi_thr: Lower and higher thresholds for time derivative of voltage.
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
%   Inspired by Sekerli, Del Negro, Lee and Butera. IEEE Trans. Biomed. Eng.,
%	51(9): 1665-71, 2004.

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

if ~ exist('plotit')
  plotit = 0;
end

s_props = get(s, 'props');

a_plot = [];

d2 = diff2T_h4(s.trace.data(1 : (max_idx + 2)) * s.trace.dy, s.trace.dt);
d1 = diffT(s.trace.data(1 : (max_idx + 2)) * s.trace.dy, s.trace.dt);
d2 = d2(3:(end -2));
d1 = d1(3:(end -2));
k1 = 1 + d1 .* d1;
k = d2 ./ sqrt(k1 .* k1 .* k1);
%# Find maximum of k between given derivative thresholds and on the rising edge
constrained_idx = find(d1 >= lo_thr & d1 <= hi_thr & d2 > 0);
if length(constrained_idx) == 0 
  warning('spike_shape:threshold_derivative', ...
	  ['Failed to find any points between derivative thresholds (' ...
	   num2str(lo_thr), num2str(hi_thr) ') while v'''' > 0. ' ...
	   'Using supersampled slope threhold crossing method (7) instead.']);
  [init_idx a_plot] = ...
      calcInitVmSlopeThresholdSupsample(s, max_idx, min_idx, ...
					s_props.init_threshold, plotit);
  return;
else    
  [val, idx] = max(k(constrained_idx)); 
  idx = constrained_idx(idx);
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
		     'max of K_p = v\prime\prime[1 + v\prime^2]^{-3/2}, ' ... 
		     'while ' num2str(lo_thr) ' < v\prime < ' num2str(hi_thr) ], ...
		    {'v\prime', 'v\prime\prime', 'K_p', ...
		     'v', 'thr'}, 'plot');
end
init_idx = idx;
