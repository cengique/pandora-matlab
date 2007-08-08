function colors = colormapBlueCrossRed(num_half_colors)

% colormapBlueCrossRed - Blue to red crossing colormap, with a black-colored zero-crossing.
%
% Usage:
% colors = colormapBlueCrossRed(num_half_colors)
%
% Description:
%   Colormap contains (2 * num_half_colors + 1) colors, where (num_half_colors + 1) is the 
% zero crossing.
%
% Parameters:
%	num_half_colors: Number of colors to generate on one of the red or blue scales.
%	props: A structure with any optional properties.
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
% http://opensource.org/licenses/afl-3.0.txt.

%#num_half_colors = floor(num_colors / 2);

%# Pick boundaries for red and blue coordinates in hue dimension
h_blue_start = 0.5;
h_blue_end = 0.66;
h_red_start = 0.0;
h_red_end = 0.14;

%# Normalized logarithmic scale for volume increments
v_min = 0.1;
v_max = 10;
v_levels = ...
    ( log(v_min:(v_max - v_min)/num_half_colors:v_max)' - log(v_min)) / ...
    ( log(v_max/v_min) );
blue_levels = ...
    hsv2rgb([(h_blue_start:(h_blue_end-h_blue_start)/num_half_colors:h_blue_end)', ...
	     ones(num_half_colors + 1, 1),  flipud(v_levels)]);
red_levels = ...
    hsv2rgb([(h_red_start:(h_red_end-h_red_start)/num_half_colors:h_red_end)', ...
	     ones(num_half_colors + 1, 1),  v_levels]);

%# Skip overlapping black color in the middle
colors = [blue_levels; red_levels(2:end, :)];

