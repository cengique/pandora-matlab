function a_plot = plot_image(image_data, axis_labels, ...
                             colorbar_label, ...
                             title_str, props)

% plot_image - Generic image plot.
%
% Usage:
% a_plot = plot_image(image_data, axis_labels, colorbar_label, title_str, props)
%
% Description:
%   Subclass of plot_abstract. The plot_abstract/plot command can be used to
% plot this data. Needed to create this as a separate class to have the
% axis ranges method implemented and take advantage of plot_abstract props.
%
% Parameters:
%   image_data: 2D matrix with image data.
%   axis_labels: Cell array for X, Y axis labels.
%   colorbar_label: String to appear next to colorbar.
%   title_str: Plot description.
%   props: A structure with any optional properties.
%     colorbar: If defined, show colorbar next to plot.
%     numGrads: Number of poles in the colormap gradient. If 1 (default),
%	  it will be a monocolor gradient (e.g., gray-level); if 2, it will
%	  be a dual-color gradient (e.g., blue to red) with a black
%	  crossing point. This point is determined by the minValue
%	  (below). Default numGrads=2, if negative values exist in
%	  image_data after scaling.
%     minValue,maxValue: Use these value to scale the data by 
%	  (image_data - minValue) / (maxValue - minValue). 
%	  Otherwise, its min and max is used.
%     colormap: Colormap vector, function name or handle to colormap (e.g., 'jet').
%     numColors: Number of colors in colormap.
%     (Rest passed to plotImage.)
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
% >> plotFigure(plot_image(rand(5), {'r1', 'r2'}, 'rand', 'random matrix'))
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
    props = struct;
  end

  if isfield(props, 'numColors')
    num_colors = props.numColors;
  else
    num_colors = 50;
  end

  if isfield(props, 'colormap')
    a_colormap = props.colormap;
  else
    a_colormap = [];
  end

  
  if isfield(props, 'maxValue')
    max_val = props.maxValue;
  else
    max_val = max(max(abs(image_data)));
  end

  if isfield(props, 'minValue')
    min_val = props.minValue;
  else
    min_val = min(min(abs(image_data)));
  end

  image_data = (image_data - min_val) ./ (max_val - min_val) * num_colors;
  is_symmetric = any(any(image_data < 0));

  if isfield(props, 'numGrads')
    num_grads = props.numGrads;
  else
    num_grads = 1;
  end
  
  image_props = struct;
  image_props.colorbarLabel = colorbar_label;
  image_props.maxValue = max_val;
    
  % convert image_data to color values and handle colorbar
  if is_symmetric || num_grads == 2
    % symmetric
    image_data = image_data + num_colors;
    % first color for indicates blank for NaN values
    if isempty(a_colormap)
      a_colormap = [1 1 1; colormapBlueCrossRed(num_colors)];
    end

    image_props.colorbarProps = struct;
    image_props.colorbarProps.YTick = ...
        [2, num_colors + 1, 2*num_colors + 1];
    if isfield(props, 'colorbarProps') && ...
       isfield(props.colorbarProps, 'YTickLabel') 
      image_props.colorbarProps.YTickLabel = ...
          props.colorbarProps.YTickLabel;
    else
      image_props.colorbarProps.YTickLabel = ...
          [ 2 * min_val - max_val, min_val, max_val ];
    end
  else
    % monocolor gradient
    if isempty(a_colormap)
      a_colormap = gray(num_colors);
    end
    image_props.colorbarProps = struct;
    image_props.colorbarProps.YTick = ...
        [2:((num_colors - 2)/3):num_colors];
    image_props.colorbarProps.YTickLabel = ...
        image_props.colorbarProps.YTick ./ num_colors .* max_val;
  end

  a_plot = ...
      class(struct, 'plot_image', ...
            plot_abstract({image_data, ...
                      a_colormap, num_colors, ...
                      mergeStructs(props, image_props)}, ...
                          axis_labels, title_str, {}, @plotImage, props));
end

