function new_axis = setAxisNonNaN(layout_axis)

% setAxisNonNaN - Returns the limits of the current axis replaced with the non-NaN elements of the given vector.
% 
% Usage:
% new_axis = setAxisNonNaN(layout_axis)
%
% Description:
%
%   Parameters:
%	layout_axis: The axis position to layout this plot. 
%		
%   Returns:
%	new_axis: Modified axis.
%
% Example:
% >> axis(setAxisNonNaN([0 100 NaN NaN])) % only change the x-axis limits
%
% See also: plot_abstract
%
% $Id: plot.m 818 2007-08-28 20:28:51Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2007/10/29

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

  new_axis = axis;
  % Skip NaNs, allows fixing some ranges while keeping others flexible
  nonnans = ~isnan(layout_axis);
  new_axis(nonnans) = layout_axis(nonnans);
end