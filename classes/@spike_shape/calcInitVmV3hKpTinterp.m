function [init_idx, a_plot] = calcInitVmV3hKpTinterp(s, max_idx, min_idx, ...
						     lo_thr, hi_thr, plotit)

% calcInitVmV3hKpTinterp - Calculates candidates for action potential threshold using the first three time-domain derivatives.
%
% Usage:
% [init_idx, a_plot] = 
%   calcInitVmV3hKpTinterp(s, max_idx, min_idx, lo_thr, hi_thr, plotit)
%
% Description:
%   First uses interpolation to increase time points. Calculates h,
% the second derivative of phase-plane (d^2 v'/dv^2), in terms of 
% time-domain derivatives. Also calculates Kp = V''[1 + (V')^2]^(-3/2), 
% the curvature. The maxima of these functions are used as candidates 
% for AP thresholds.
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
%	init_idx: Indices of threshold candidates in the spike_shape [dt].
%	a_plot: plot_abstract, if requested.
%
% See also: calcInitVm
%
% $Id$
%
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2004/11/18
%   Taken from Sekerli, Del Negro, Lee and Butera. IEEE Trans. Biomed. Eng.,
%	51(9): 1665-71, 2004.

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

if ~ exist('plotit')
  plotit = 0;
end
a_plot = [];

%# Supersampling factor (times as many new data points)
int_fac = 4; 

%#num_points = 200;

%#interp_v = interp(s.trace.data(1 : max_idx), int_fac)';
interp_v = pchip(1 : max_idx, s.trace.data(1 : max_idx), ...
		 (1 : (max_idx * int_fac))/int_fac)';
dt = s.trace.dt / int_fac;

size(interp_v)

d3 = diff3T_h4(interp_v * s.trace.dy, dt);
d2 = diff2T_h4(interp_v * s.trace.dy, dt);
d1 = diffT(interp_v * s.trace.dy, dt);

%# Remove boundary artifacts
d3 = d3(3:(end - 2)); 
d2 = d2(3:(end - 2));
d1 = d1(3:(end - 2));

%# Find desired lower boundary of region of interest
low_d1_idx = find(d1 > lo_thr);
if length(low_d1_idx) == 0 
  error('calcInitVm:failed', ...
	['Failed to find any points below low derivative threshold ' ...
	 num2str(lo_thr) ]);
end
low_d1_idx = low_d1_idx(1);

hi_d1_idx = find(d1 < hi_thr);
if length(hi_d1_idx) == 0 
  error('calcInitVm:failed', ...
	['Failed to find any points above high derivative threshold ' ...
	 num2str(hi_thr) ]);
end
hi_d1_idx = hi_d1_idx(end);

[max_d1, max_d1_idx] = max(d1);

%# Sekerli's method, max of second derivative
h = (d3 .* d1 - d2 .* d2) ./ (d1 .* d1 .* d1);

s_props = get(s, 'props');

%# OBSOLETE, SEE BELOW.
%# If specified, use threshold as upper limit
if isfield(s_props, 'init_threshold')
  add_h_title = [', while v\prime < ' num2str(s_props.init_threshold)];
  constrained_idx = find(d1 < s_props.init_threshold);
  if length(constrained_idx) == 0 
    error('calcInitVm:failed', ...
	    ['Failed to find any points below derivative threshold ' ...
	     num2str(s_props.init_threshold) ]);
  else    
    [val, max_h_idx] = max(h(constrained_idx)); 
    max_h_idx = constrained_idx(max_h_idx);
  end
else
  add_h_title = '';
  [val, max_h_idx] = max(h); 
end
max_h_idx = (max_h_idx + 2) / int_fac;

%# Curvature
k1 = 1 + d1 .* d1;
k = d2 ./ sqrt(k1 .* k1 .* k1);

%# Find maximum of k between given derivative thresholds and on the rising edge
constrained_idx = find(d1 >= lo_thr & d1 <= hi_thr & d2 > 0);
if length(constrained_idx) == 0 
  warning('calcInitVm:failed', ...
	  ['Failed to find any points between derivative thresholds (' ...
	   num2str(lo_thr), ' - ', num2str(hi_thr) ') while v'''' > 0. ' ...
	   'Using supersampled slope threshold crossing method (7) instead.']);
  max_k_idx = NaN;
  max_h_idx = NaN;
  [max_slope_idx a_plot] = ...
      calcInitVmSlopeThresholdSupsample(s, max_idx, min_idx, ...
					s_props.init_threshold, plotit);
else    
  [val, max_k_idx] = max(k(constrained_idx)); 
  max_k_idx = (constrained_idx(max_k_idx) + 2) / int_fac;

  [val, max_h_idx] = max(h(constrained_idx)); 
  max_h_idx = constrained_idx(max_h_idx);
  max_h_idx = (max_h_idx + 2) / int_fac;
end

if plotit
  t = (3 : (int_fac * max_idx - 2)) * dt * 1e3;
  if isfield(s_props, 'quiet') || isfield(s.trace.props, 'quiet')
    title_str = '';
  else
    title_str = [ strrep(class(s), '_', ' ') ': ' get(s, 'id') ', ' ];
  end
  a_plot = ...
      plot_abstract({(1:max_idx) * s.trace.dt * 1e3, ...
		     s.trace.data(1:max_idx)/max(abs(s.trace.data(1:max_idx))), ...
		     (1:(max_idx * int_fac)) * dt * 1e3, ...
		     interp_v/max(abs(interp_v)), ...
		     t, d1/max(abs(d1)), t, d2/max(abs(d2)), ...
		     t, d3/max(abs(d3)), t, h/max(abs(h)), '.-', ...
		     t, k/max(abs(k)), '.-', ...
		     max_h_idx * s.trace.dt * 1e3, ...
		     interp_v(max_h_idx * int_fac)/max(abs(interp_v)), 's', ...
		     max_k_idx * s.trace.dt * 1e3, ...
		     interp_v(max_k_idx * int_fac)/max(abs(interp_v)), 'vk', ...
		     }, ...
		    {'time [ms]', 'normalized'}, ...
		    [ title_str 'time-plane methods, ' ...
		     'max of h = d^2v\prime/dv^2' add_h_title ...
		     ' and curvature K_p = v\prime\prime[1 + v\prime^2]^{-3/2}, ' ... 
		     'while ' num2str(lo_thr) ' < v\prime < ' num2str(hi_thr)], ...
		    {['v / ' sprintf('%.2e', max(abs(s.trace.data(1:max_idx))))], ...
		     ['v / ' sprintf('%.2e', max(abs(interp_v))) ' (interp)'], ...
		     ['v\prime / ' sprintf('%.2e', max(abs(d1))) ], ...
		     ['v\prime\prime / ' sprintf('%.2e', max(abs(d2))) ], ...
		     ['v\prime\prime\prime / ' sprintf('%.2e', max(abs(d3))) ], ...
		     ['h / ' sprintf('%.2e', max(abs(h))) ], ...
		     ['K_p / ' sprintf('%.2e', max(abs(k))) ], ...
		     'max h(t)', 'max K_p(t)'}, 'plot');
%#		     sprintf('\n') ...
  a_plot = setProp(a_plot, 'axisLimits', ...
		   [(low_d1_idx * dt * 1e3) (max_idx * s.trace.dt * 1e3) NaN NaN]);
end
init_idx = [ max_h_idx max_k_idx ];
