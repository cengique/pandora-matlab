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
%	  truncateDecDigits: Truncate labels to this many decimal digits.
%	  maxValue: Maximal value at num_colors to annotate the colorbar.
%		
% Returns:
%	colors: RGB color matrix to be passed to colormap function.
%
% See also: colormap
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/06/05

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

h = image(image_data);

% Show up to num_colors
colormap(feval(colormap_func, num_colors)); 

% Truncate some digits to unify parameter values estranged by numerical error
if isfield(props, 'truncateDecDigits')
  mult_factor = 10^props.truncateDecDigits;
else
  mult_factor = 10^3;
end

if isfield(props, 'colorbar')
  hc = colorbar;
  
  if isfield(props, 'maxValue')
      max_val = props.maxValue;
  else
      max_val = num_colors;             % Default normalized display
  end
  set(hc, 'YTickMode', 'manual');
  set(hc, 'YTickLabelMode', 'manual');
  yticks = get(hc, 'YTick');
  set(hc, 'YTickLabel', round(yticks .* max_val .* mult_factor ./ num_colors) ./ mult_factor);
end

% scale font to fit measure names on y-axis
num_rows = max(100, size(image_data, 1));
%set(gca, 'FontUnit', 'normalized', 'FontSize', 1/num_rows);

end
