function a_plot = plotCompareMethods(s)

% plotCompareMethods - Creates a multi-plot comparing different action potential
%			threshold finding methods.
%
% Usage:
% a_plot = plotCompareMethods(s)
%
% Description:
%
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
%   Cengiz Gunay <cgunay@emory.edu>, 2004/11/19

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

%# Adjust plots
r_plot = set(plotResults(sm3), 'title', ['Slope threshold, v\prime > ' num2str(th) ]);
r_plot = setProp(r_plot, 'axisLimits', ...
		 [peak_time - 3, min_time, NaN, NaN]);
m3_plot = plot_stack({r_plot, plotTPP(sm3)}, [], 'x', '', struct([]));

%# Method 4 (non-parameteric)
sm4 = set(s, 'props', struct('init_Vm_method', 4));
[res, d_plot] = getResults(sm4, 1);
d_plot = setProp(d_plot, 'axisLimits', [peak_time - 3, peak_time, NaN, NaN]);
r_plot = setProp(plotResults(sm4), 'axisLimits', [peak_time - 3, min_time, NaN, NaN]);
m4_plot = plot_stack({r_plot, d_plot}, [], 'x', get(d_plot, 'title'), ...
		     struct('titlesPos', 'none'));

%# Method 4 (parameteric)
sm4p = set(s, 'props', struct('init_Vm_method', 6, 'init_threshold', 10));
[res, d_plot] = getResults(sm4p, 1);
d_plot = setProp(d_plot, 'axisLimits', [peak_time - 3, peak_time, NaN, NaN]);
r_plot = setProp(plotResults(sm4p), 'axisLimits', [peak_time - 3, min_time, NaN, NaN]);
m4p_plot = plot_stack({r_plot, d_plot}, [], 'x', get(d_plot, 'title'), ...
		      struct('titlesPos', 'none'));

%# Method 5 (non-parameteric)
sm5 = set(s, 'props', struct('init_Vm_method', 5));
[res, d_plot] = getResults(sm5, 1);
d_plot = setProp(d_plot, 'axisLimits', [peak_time - 3, peak_time, NaN, NaN]);
r_plot = setProp(plotResults(sm5), 'axisLimits', [peak_time - 3, min_time, NaN, NaN]);
m5_plot = plot_stack({r_plot, d_plot}, [], 'x', get(d_plot, 'title'), ...
		     struct('titlesPos', 'none'));

class_name = strrep(class(s), '_', ' ');
a_plot = plot_stack({m3_plot, m4p_plot, m5_plot}, [], 'y', ...
		    [ class_name ': ' get(s, 'id') ...
		     ', Comparison of AP threshold finding methods']);
