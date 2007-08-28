function a_plot = plot_errorbars(mid_vals, lo_vals, hi_vals, labels, ...
				title, axis_limits, props)

% plot_errorbars - Plots distributions of variables with errorbars in separate axes.
%
% Usage:
% a_plot = plot_errorbars(labels, mid_vals, lo_vals, hi_vals, labels, 
%			 title, axis_limits, props)
%
% Description:
%   Subclass of plot_stack. The plot_abstract/plot command can be used to
% plot this data. Each of mid_vals, lo_vals, and hi_vals plot its rows in
% the same axis and columns in different axes.
%
%   Parameters:
%	labels: Labels of parameters to appear at bottom of each errorbar.
%	mid_vals: Middle points of error bars.
%	lo_vals: Low points of error bars.
%	hi_vals: High points of error bars.
%	title: Plot description.
%	axis_limits: If given, all plots contained will have these axis limits.
%	props: A structure with any optional properties.
%		
%   Returns a structure object with the following fields:
%	plot_abstract, labels.
%
% General operations on plot_errorbars objects:
%   plot_errorbars	- Construct a new plot_errorbars object.
%
% Additional methods:
%	See methods('plot_errorbars')
%
% See also: plot_abstract, plot_abstract/plot
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/07

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 %# Called with no params
   a_plot.labels = {};
   a_plot = class(a_plot, 'plot_errorbars', plot_stack);
 elseif isa(labels, 'plot_errorbars') %# copy constructor?
   a_plot = labels;
 else
   if ~ exist('props')
     props.rotateXLabel = 45; %# Degrees
     %#props.XTickLabel = 1;
   end

   if ~ exist('axis_limits')
     axis_limits = []; %# Degrees
   end

   a_plot.labels = labels;

   num_plots = size(mid_vals, 2);
   num_rows = size(mid_vals, 1)
   plots = cell(1, num_plots);
   %# Loop for each item and create a horizontal stack of plots
   for plot_num=1:num_plots
     plots{plot_num} = ...
	 plot_abstract({1:num_rows, mid_vals(:,plot_num), lo_vals(:,plot_num), ...
			hi_vals(:,plot_num), 'd'}, ...
		       {labels{plot_num}, ''}, '', {}, 'errorbar', props);
   end

   a_plot = class(a_plot, 'plot_errorbars', ...
		  plot_stack(plots, axis_limits, 'x', title, props));
end

