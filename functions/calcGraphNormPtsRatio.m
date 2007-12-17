function [ratio_x, ratio_y] = calcGraphNormPtsRatio(grfx_handle)

%  calcGraphNormPtsRatio - Return the ratios of normalized to point units for dimensions of axis.
%
% Usage:
% [ratio_x, ratio_y] = calcGraphNormPtsRatio(grfx_handle)
%
% Description:
%   Used for findind character sizes given the size of an axis. Normally if the plot
% is resized, the characters may take up too much space or may not fit anymore unless
% the spacing is corrected.
%
% Parameters:
%	grfx_handle: A graphics handle to an existing axis or figure.
%
% Returns:
% 	ratio_x, ratio_y: Normalized to points ratio for axis width and height, respectively.
%
% Example:
% To find the normalized distance for a 10pt character:
% >> dx = 10 * calcGraphNormPtsRatio(my_figure_handle);
%
% $Id: calcGraphNormPtsRatio.m,v 1.2 2006/08/11 16:52:14 cengiz Exp $
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/03/05

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

grf_type = get(grfx_handle, 'Type');
switch grf_type
    case 'axes'
      layout_axis = get(grfx_handle, 'Position');
      width = layout_axis(3);
      height = layout_axis(4);

    case 'figure'
      % Whole figure is normalized to unity
      width = 1;
      height = 1;
      
    otherwise
      error(['Unknown type ''' grf_type ''' of graphics handle!']);
end

% Find the width of a regular y-axis label 
old_units = get(grfx_handle, 'Units');
set(grfx_handle, 'Units', 'points');
axis_pos_pt = get(grfx_handle, 'Position');
axis_width_pt = axis_pos_pt(3);
axis_height_pt = axis_pos_pt(4);
set(grfx_handle, 'Units', old_units);

% Fixed size for ticks and labels
ratio_x = width / axis_width_pt;
ratio_y = height / axis_height_pt;

