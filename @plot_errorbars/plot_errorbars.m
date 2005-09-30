function a_plot = plot_errorbars(mid_vals, lo_vals, hi_vals, labels, ...
				title, axis_limits, props)

% plot_errorbars - Special plot for plotting distributions of variables in separate axes.
%
% Usage:
% a_plot = plot_errorbars(labels, mid_vals, lo_vals, hi_vals, labels, 
%			 title, axis_limits, props)
%
% Description:
%   Subclass of plot_abstract. The plot_abstract/plot command can be used to
% plot this data.
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
%	plot_abstract, labels, props.
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
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/07

if nargin == 0 %# Called with no params
   a_plot.labels = {};
   a_plot.props = struct([]);
   a_plot = class(a_plot, 'plot_errorbars', plot_abstract);
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
   a_plot.props = props;

   num_plots = size(mid_vals, 2);
   plots = cell(1, num_plots);
   %# Loop for each item and create a horizontal stack of plots
   for plot_num=1:num_plots
     plots{plot_num} = ...
	 plot_abstract({1, mid_vals(:,plot_num), lo_vals(:,plot_num), ...
			hi_vals(:,plot_num), 'd'}, ...
		       {labels{plot_num}, ''}, '', {}, 'errorbar', props);
   end

   a_plot = class(a_plot, 'plot_errorbars', ...
		  plot_stack(plots, axis_limits, 'x', title, props));
end

