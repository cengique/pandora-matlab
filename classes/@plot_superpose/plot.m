function handles = plot(a_plot, layout_axis)

% plot - Draws this plot in the current axis.
%
% Usage:
% handles = plot(a_plot, layout_axis)
%
% Description:
%
%   Parameters:
%	a_plot: A plot_superpose object.
%	layout_axis: The axis position to layout this plot (Optional). 
%		
%   Returns:
%	handles: Handles of graphical objects drawn.
%
% See also: plot_abstract
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/04/08

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

%# TODO: save the axis handle!
if ~ exist('layout_axis')
  layout_axis = [];
%#  axes('position', layout_axis);
end

num_plots = length(a_plot.plots);

all_handles = [];
for plot_num = 1:num_plots
  if plot_num > 1
    %# only allow the first plot to open the axis
    layout_axis = NaN; %# NaN means don't open new axis
    hold all;
  end
  handles = plot(a_plot.plots{plot_num}, layout_axis); 
  all_handles = [all_handles, handles];
end
hold off;

handles = all_handles;