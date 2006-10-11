function h = plotImage(image_data, colormap_func, num_colors, props)

% plotImage - Function that plots a color matrix on current figure.
%
% Usage:
% h = plotImage(image_data, colormap_func, num_colors, props)
%
% Description:
%
% Parameters:
%	image_data: 2D matrix with image data.
%	colormap_func: Function name or handle to colormap (e.g., 'jet').
% 	num_colors: Parameter to be passed to the colormap_func.
%	props: A structure with any optional properties.
%	  colorbar: If defined, show colorbar on plot.
%		
% Returns:
%	colors: RGB color matrix to be passed to colormap function.
%
% See also: colormap
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/06/05

h = image(image_data);

%# Show up to num_colors
colormap(feval(colormap_func, num_colors)); 

if isfield(props, 'colorbar')
  hc = colorbar;
end

%# scale font to fit measure names on y-axis
num_rows = max(100, size(image_data, 1));
%#set(gca, 'FontUnit', 'normalized', 'FontSize', 1/num_rows);

end
