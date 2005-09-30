function a_plot = plot_bars(mid_vals, lo_vals, hi_vals, n_vals, labels, ...
			    title, axis_limits, props)

% plot_bars - Bar plot for mean and variation of variables in separate axes.
%
% Usage:
% a_plot = plot_bars(labels, mid_vals, lo_vals, hi_vals, n_vals, labels, 
%			 title, axis_limits, props)
%
% Description:
%   Subclass of plot_abstract. The plot_abstract/plot command can be used to
% plot this data.
%
%   Parameters:
%	mid_vals: Middle points of error bars.
%	lo_vals: Low points of error bars.
%	hi_vals: High points of error bars.
%	n_vals: Number of samples used for the statistic (Optional).
%	labels: Labels of parameters to appear at bottom of each errorbar.
%	title: Plot description.
%	axis_limits: If given, all plots contained will have these axis limits.
%	props: A structure with any optional properties.
%		
%   Returns a structure object with the following fields:
%	plot_abstract, labels, props.
%
% General operations on plot_bars objects:
%   plot_bars	- Construct a new plot_bars object.
%
% Additional methods:
%	See methods('plot_bars')
%
% See also: plot_abstract, plot_abstract/plot
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/07

if nargin == 0 %# Called with no params
   a_plot.labels = {};
   a_plot.props = struct([]);
   a_plot = class(a_plot, 'plot_bars', plot_abstract);
 elseif isa(labels, 'plot_bars') %# copy constructor?
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
	 plot_superpose([plot_abstract({1:size(mid_vals, 1), ...
					mid_vals(:,plot_num)}, ...
				       {labels{plot_num}, ''}, ...
				       '', {}, 'bar', props),...
			 plot_abstract({1:size(mid_vals, 1), mid_vals(:,plot_num), ...
					lo_vals(:,plot_num), hi_vals(:,plot_num), '+'}, ...
				       {labels{plot_num}, ''}, ...
				       '', {}, 'errorbar', props), ...
			 plot_abstract({1:size(mid_vals, 1), ...
					mid_vals(:,plot_num) + hi_vals(:,plot_num), ...
					cellstr(strcat('n=', ...
						       num2str(n_vals(:,plot_num)))), ...
					'HorizontalAlignment', 'center', ...
					'VerticalAlignment', 'bottom'}, ...
				       {labels{plot_num}, ''}, ...
				       '', {}, 'text', props)]);
   end

   a_plot = class(a_plot, 'plot_bars', ...
		  plot_stack(plots, axis_limits, 'x', title, props));
end

