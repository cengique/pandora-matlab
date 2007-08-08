function handles = plot(a_plot, layout_axis)

% plot - Superposes contained plots in their own axes.
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
% Author: Cengiz Gunay <cgunay@emory.edu>, 2007/06/08

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

%# TODO: save the axis handle!
if ~ exist('layout_axis')
  layout_axis = [0 0 1 1];
end

num_plots = length(a_plot.plots);

all_handles = [];
this_layout_axis = layout_axis;

% open individual axes
for plot_num = 1:num_plots

  if plot_num > 1
    % place others relative to 1st plot axis
    % TODO: does children only take part of parent anyway?
    layout_axis = get(gca, 'Position');
  end
  
  this_axis = a_plot.axis_locations(plot_num, :);

  % offset and scale given location to layout_axis
  this_layout_axis(1:2) = layout_axis(1:2) + this_axis(1:2);
  this_layout_axis(3:4) = layout_axis(3:4) .* this_axis(3:4);    

  % plot it
  handles = plot(a_plot.plots{plot_num}, this_layout_axis); 
  all_handles = [all_handles, handles];

  % apply each plot's decoration separately
  decorate(a_plot.plots{plot_num});
end

handles = all_handles;