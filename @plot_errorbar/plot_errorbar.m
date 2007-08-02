function a_plot = plot_errorbar(x_vals, mid_vals, lo_vals, hi_vals, line_spec, ...
				axis_labels, title, legend, props)

% plot_errorbar - Generic errorbar plot.
%
% Usage:
% a_plot = plot_errorbar(x_vals, mid_vals, lo_vals, hi_vals, line_spec, 
%			 axis_labels, title, legend, props)
%
% Description:
%   Subclass of plot_abstract. The plot_abstract/plot command can be used to
% plot this data. Needed to create this as a separate class to have the
% axis ranges method to measure the errorbars.
%
%   Parameters:
%	x_vals: X coordinates of errorbars.
%	mid_vals: Middle points of error bars.
%	lo_vals: Low points of error bars.
%	hi_vals: High points of error bars.
%	line_spec: Plot line spec to be passed to errorbar
%	axis_labels: Cell array for X, Y axis labels.
%	title: Plot description.
%	legend: For multiple errorbar plots (matrix form), description of each plot.
%	props: A structure with any optional properties to be passed to plot_abstract.
%		
%   Returns a structure object with the following fields:
%	plot_abstract.
%
% General operations on plot_errorbar objects:
%   plot_errorbar	- Construct a new plot_errorbar object.
%
% Additional methods:
%	See methods('plot_errorbar')
%
% See also: plot_abstract, plot_abstract/plot
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/07

%# Note: class exists only because the axis method needs to be overridden

if nargin == 0 %# Called with no params
  a_plot = class(a_plot, 'plot_errorbar', plot_abstract);
elseif isa(x_vals, 'plot_errorbar') %# copy constructor?
  a_plot = x_vals;
else
  if ~ exist('props')
    props = struct([]);
  end

  a_plot = class(struct, 'plot_errorbar', ...
		 plot_abstract({x_vals, mid_vals, lo_vals, hi_vals}, ...
			       axis_labels, title, legend, 'errorbar', ...
			       props));
end

