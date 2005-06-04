function a_plot = plot_simple(data_x, data_y, title, label_x, label_y, ...
			      legend, command, props)

% plot_simple - Abstract description of a single plot.
%
% Usage:
% a_plot = plot_simple(data_x, data_y, title, 
%		       label_x, label_y, legend, command, props)
%
% Description:
%   Subclass of plot_abstract. The plot_abstract/plot command can be used to
% plot this data.
%
%   Parameters:
%	data_x: X-axis values for the plot.
%	data_y: Y-axis values for the plot.
%	title: Plot description.
%	label_x: X-axis label string.
%	label_y: Y-axis label string.
%	legend: Short description of data points.
%	command: Plotting command to use (Optional, default='plot')
%	props: A structure with any optional properties.
%		
%   Returns a structure object with the following fields:
%	plot_abstract, props.
%
% General operations on plot_simple objects:
%   plot_simple		- Construct a new plot_simple object.
%
% Additional methods:
%	See methods('plot_simple')
%
% See also: plot_abstract, plot_abstract/plot
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/22

if nargin == 0 %# Called with no params
   %#a_plot.props = struct([]);
   a_plot = class(struct, 'plot_simple', plot_abstract);
 elseif isa(data_x, 'plot_simple') %# copy constructor?
   a_plot = data_x;
 else
   if ~ exist('props')
     props = struct([]);
   end

   if ~ exist('command')
     command = 'plot';
   end

   %#a_plot.props = props;

   a_plot = class(struct, 'plot_simple', ...
		  plot_abstract({data_x, data_y}, {label_x, label_y}, ...
				title, {legend}, command, props));
end

