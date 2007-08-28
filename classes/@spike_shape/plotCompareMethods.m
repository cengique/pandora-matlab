function a_plot = plotCompareMethods(s, title_str)

% plotCompareMethods - Creates a multi-plot comparing different action potential
%			threshold finding methods.
%
% Usage:
% a_plot = plotCompareMethods(s, title_str)
%
% Description:
%
%   Parameters:
%	s: A spike_shape object.
%	title_str: Title suffix (optional).
%
%   Returns:
%	a_plot: A plot_abstract object that can be visualized.
%
% See also: spike_shape, plot_abstract
%
% $Id$
%
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2004/11/19

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

%# Two column plot area, best methods on the left:
%# - threshold to slope (parametric)
%# - Sekerli's 2nd derivative in phase space (parametric/non-parameteric)
%# - Maximum curvature (non-parameteric)
%#
%# On the right, phase space plot, derivative plots and h and Kp

%# Method 3
th = 15;
sm3 = set(s, 'props', struct('init_Vm_method', 3, 'init_threshold', th));
resultsm3 = getResults(sm3);
init_idx = resultsm3.InitTime ;
rise_time = resultsm3.RiseTime ;
peak_time = init_idx + rise_time;
min_time = resultsm3.MinTime;

%# Method 7, slope threshold with supersampling
sm7 = set(s, 'props', struct('init_Vm_method', 7, 'init_threshold', th));
resultsm7 = getResults(sm7);

r2_plot = set(plotResults(sm7), 'title', ['Slope threshold (interp.), v\prime > ' num2str(th) ]);
r2_plot = setProp(r2_plot, 'axisLimits', ...
		 [resultsm7.InitTime - 1, resultsm7.InitTime + 1, ...
		  resultsm7.InitVm - 5, resultsm7.InitVm + 5]);

%# Adjust plots
r_plot = set(plotResults(sm3), 'title', ['Slope threshold, v\prime > ' num2str(th) ]);
r_plot = setProp(r_plot, 'axisLimits', ...
		 [resultsm3.InitTime - 1, resultsm3.InitTime + 1, ...
		  resultsm3.InitVm - 5, resultsm3.InitVm + 5]);

r3_plot = set(plotTPP(sm3), 'title', [ 'In phase-plane (v\prime vs. v)' ]);

m3_plot = plot_stack({r_plot, r2_plot, r3_plot}, [], 'x', '', struct([]));

%# Method 8 (non-parameteric): maximal curvature in phase-plane
sm8 = set(s, 'props', struct('init_Vm_method', 8));
[res, d_plot] = getResults(sm8, 1);
%#d_plot = setProp(d_plot, 'axisLimits', [peak_time - 3, peak_time, NaN, NaN]);
r_plot = setProp(plotResults(sm8), 'axisLimits', ...
		 [res.InitTime - 1, res.InitTime + 1, ...
		  res.InitVm - 5, res.InitVm + 5]);
m8_plot = plot_stack({r_plot, d_plot}, [], 'x', get(d_plot, 'title'), ...
		     struct('titlesPos', 'none'));

%# Method 4 (parameteric): Sekerli's method with threshold
sm4p = set(s, 'props', struct('init_Vm_method', 6, 'init_threshold', 10));
[res, d_plot] = getResults(sm4p, 1);
d_plot = setProp(d_plot, 'axisLimits', [peak_time - 3, peak_time, NaN, NaN]);
r_plot = setProp(plotResults(sm4p), 'axisLimits', ...
		 [res.InitTime - 1, res.InitTime + 1, ...
		  res.InitVm - 5, res.InitVm + 5]);
m4p_plot = plot_stack({r_plot, d_plot}, [], 'x', get(d_plot, 'title'), ...
		      struct('titlesPos', 'none'));

%# Method 4 (non-parameteric): Sekerli's method
sm4 = set(s, 'props', struct('init_Vm_method', 4, 'init_threshold', 15));
[res, d_plot] = getResults(sm4, 1);
d_plot = setProp(d_plot, 'axisLimits', [peak_time - 3, peak_time, NaN, NaN]);
r_plot = setProp(plotResults(sm4), 'axisLimits', ...
		 [res.InitTime - 1, res.InitTime + 1, ...
		  res.InitVm - 5, res.InitVm + 5]);
m4_plot = plot_stack({r_plot, d_plot}, [], 'x', get(d_plot, 'title'), ...
		      struct('titlesPos', 'none'));

%# Method 5 (non-parameteric)
sm5 = set(s, 'props', struct('init_Vm_method', 5, ...
			     'init_lo_thr', 5, 'init_hi_thr', 50, ...
			     'init_threshold', 15));
[res, d_plot] = getResults(sm5, 1);
d_plot = setProp(d_plot, 'axisLimits', [peak_time - 3, peak_time, NaN, NaN]);
r_plot = setProp(plotResults(sm5), 'axisLimits', ...
		 [res.InitTime - 1, res.InitTime + 1, ...
		  res.InitVm - 5, res.InitVm + 5]);
m5_plot = plot_stack({r_plot, d_plot}, [], 'x', get(d_plot, 'title'), ...
		     struct('titlesPos', 'none'));

if ~ exist('title_str')
  title_str = ', Comparison of AP threshold finding methods';
end

class_name = strrep(class(s), '_', ' ');
a_plot = plot_stack({m3_plot, m4_plot, m5_plot, m8_plot}, [], 'y', ...
		    [ class_name ': ' get(s, 'id') ...
		     title_str ]);
