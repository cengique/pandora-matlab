function a_plot = plotCompareMethodsSimple(s, title_str)

% plotCompareMethodsSimple - Creates a multi-plot comparing different action potential
%			threshold finding methods.
%
% Usage:
% a_plot = plotCompareMethodsSimple(s, title_str)
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

% Two column plot area, best methods on the left:
% - threshold to slope (parametric)
% - Sekerli's 2nd derivative in phase space (parametric/non-parameteric)
% - Maximum curvature (non-parameteric)
%
% On the right, phase space plot, derivative plots and h and Kp

top_plot_title = get(s, 'id');
s = setProp(s, 'quiet', 1); % Stop from cluttering remaining plots

% Method 3
th = 15;
sm3 = set(s, 'props', struct('init_Vm_method', 3, 'init_threshold', th));
resultsm3 = getResults(sm3);
r3_plot = set(plotTPP(sm3), 'title', [ 'In phase-plane (v\prime vs. v)' ]);

% Get general values from method 3
init_idx = resultsm3.InitTime ;
rise_time = resultsm3.RiseTime ;
peak_time = init_idx + rise_time;
min_time = resultsm3.MinTime;

[max_val, max_idx] = calcMaxVm(s);
[min_val, min_idx] = calcMinVm(s, max_idx);

% Method 7, slope threshold with supersampling
sm7 = set(s, 'props', struct('init_Vm_method', 7, 'init_threshold', th));
resultsm7 = getResults(sm7);

% Method 8 (non-parameteric): maximal curvature in phase-plane
sm8 = set(s, 'props', struct('init_Vm_method', 8, 'init_threshold', 15));
[init_idx, max_d1o, d_plot] = calcInitVmMaxCurvPhasePlane(sm8, max_idx, min_idx, 1);
vpp_plots_row = plot_stack({r3_plot, d_plot}, [], 'x', get(d_plot, 'title'), ...
		     struct('titlesPos', 'none'));

% Method 9: combined time-domain derivative methods h and Kp
try 
  [m9_init_idx, d_plot] = calcInitVmV3hKpTinterp(sm8, max_idx, min_idx, 5, 50, 1);
catch
  err = lasterror;
  if strcmp(err.identifier, 'calcInitVm:failed')
    % Set to beginning of trace just to recover form error
    [m9_init_idx(1:2)] = deal(1);
  else
    rethrow(err);
  end
end 

% plot with all derivatives, h and Kp
%d_plot = setProp(d_plot, 'axisLimits', [peak_time - 3, peak_time, NaN, NaN]);

% Get a time-domain spike shape plot 
r_plot = set(plotData(sm3), 'title', 'Found threshold candidates');
r_plot = set(r_plot, 'legend', {'v'});

% TODO: adjust limits to show all candidate points
% TODO: superpose the points on this graph
points_cell = {resultsm3.InitTime, resultsm3.InitVm, '*', ...
	       resultsm7.InitTime, resultsm7.InitVm, 'o', ...
	       init_idx(1) * s.trace.dt / 1e-3, interpV(s, init_idx(1)), 'x', ...
	       init_idx(2) * s.trace.dt / 1e-3, interpV(s, init_idx(2)), '+', ...
	       init_idx(3) * s.trace.dt / 1e-3, interpV(s, init_idx(3)), 'd', ...
	       m9_init_idx(1) * s.trace.dt * 1e3, interpV(s, m9_init_idx(1)), 's', ...
	       m9_init_idx(2) * s.trace.dt * 1e3, interpV(s, m9_init_idx(2)), 'v', ...
	       };
t_points = [points_cell{:, 1}];
v_points = [points_cell{:, 2}];
annotation_plot = plot_abstract(points_cell, ...
				{}, '', {['v\prime > ' num2str(th)], ...
					 ['v\prime > ' num2str(th) ' (interp)'], ...
					 'max K_p(v)', ...
					 'nearest max K_p(v)', ...
					 'max d^2v\prime/dv^2', ...
					 'max h(t)', 'max K_p(t)'});
r_plot = setProp(r_plot, 'axisLimits', ...
		 [min(t_points) - 1, max(t_points) + 1, ...
		  min(v_points) - 5, max(v_points) + 5]);
spike_shape_time_plot = superposePlots([annotation_plot, r_plot], {}, '');

t_plots_row = plot_stack({spike_shape_time_plot, d_plot}, ...
			 [], 'x', get(d_plot, 'title'), ...
			 struct('titlesPos', 'none'));

if ~ exist('title_str')
  title_str = ', Comparison of AP threshold finding methods';
end

class_name = strrep(class(s), '_', ' ');
a_plot = plot_stack({vpp_plots_row, t_plots_row}, [], 'y', ...
		    [ class_name ': ' top_plot_title ...
		     title_str ]);

function voltage = interpV(s, idx)
  fi = floor(idx);
  if fi <= 0
    voltage = s.trace.data(1);
  elseif idx - fi > 0
    voltage = s.trace.data(fi) + ...
	(s.trace.data(ceil(idx)) - s.trace.data(fi))*(idx - fi);
  else
    voltage = s.trace.data(fi);
  end