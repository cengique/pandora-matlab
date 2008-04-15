function a_plot = plot_image(image_data, a_colormap, num_colors, axis_labels, ...
                             title_str, props)

% plot_image - Generic errorbar plot.
%
% Usage:
% a_plot = plot_image(image_data, a_colormap, num_colors, axis_labels, title_str, props)
%
% Description:
%   Subclass of plot_abstract. The plot_abstract/plot command can be used to
% plot this data. Needed to create this as a separate class to have the
% axis ranges method implemented.
%
% Parameters:
%	image_data: 2D matrix with image data.
%	a_colormap: Colormap vector, function name or handle to colormap (e.g., 'jet').
% 	num_colors: Parameter to be passed to the a_colormap.
%	axis_labels: Cell array for X, Y axis labels.
%	title_str: Plot description.
%	props: A structure with any optional properties.
%	  colorbar: If defined, show colorbar next to plot.
%	  colorbarProps: Set colorbar axis properties.
%	  colorbarLabel: Set colorbar y-axis label.
%	  truncateDecDigits: Truncate labels to this many decimal digits.
%	  maxValue: Maximal value at num_colors to annotate the colorbar.
%	  reverseYaxis: If 1, display y-axis values in reverse (default=0).
%	  (Rest passed to plot_abstract.)

%		
%   Returns a structure object with the following fields:
%	plot_abstract.
%
% General operations on plot_image objects:
%   plot_image	- Construct a new plot_image object.
%
% Additional methods:
%	See methods('plot_image') and methods('plot_abstract')
%
% Example:
% >> plotFigure(plot_image(rand(5) * 50, @jet, 50, {}, 'hello'))
%
% See also: plot_abstract, plot_abstract/plot
%
% $Id: plot_image.m 896 2007-12-17 18:48:55Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2008/04/15

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Note: class exists only because the axis method can return meaningful
% ranges for image plots

if nargin == 0 % Called with no params
  a_plot = class(a_plot, 'plot_image', plot_abstract);
elseif isa(image_data, 'plot_image') % copy constructor?
  a_plot = image_data;
else
  if ~ exist('props')
    props = struct([]);
  end

  a_plot = ...
      class(struct, 'plot_image', ...
            plot_abstract({image_data, ...
                      a_colormap, num_colors, props}, ...
                          axis_labels, title_str, {}, @plotImage, props));
end

