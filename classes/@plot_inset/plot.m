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
% http://opensource.org/licenses/afl-3.0.php.

% TODO: save the axis handle!
if ~ exist('layout_axis', 'var')
  layout_axis = [0 0 1 1];
end

num_plots = length(a_plot.plots);

all_handles = struct('plot', [], 'axis', []);
this_layout_axis = layout_axis;

a_plot_props = get(a_plot, 'props');

% open individual axes
for plot_num = 1:num_plots

  this_axis = a_plot.axis_locations(plot_num, :);
      
  if isfield(a_plot_props, 'positioning') && ...
      strcmp(a_plot_props.positioning, 'relative')
    if plot_num > 1
      % place others relative to 1st plot axis
      % TODO: does children only take part of parent anyway?
      %layout_axis = get(gca, 'Position');
      layout_axis = a_plot.axis_locations(1, :)
    end

    % offset and scale given location to layout_axis
    this_layout_axis(1:2) = layout_axis(1:2) + (this_axis(1:2) ./ layout_axis(3:4));
    this_layout_axis(3:4) = layout_axis(3:4) .* this_axis(3:4);    
  else
    this_layout_axis = this_axis;
  end

  % plot it
  handles = plot(a_plot.plots{plot_num}, this_layout_axis); 
  all_handles.plot = [all_handles.plot, handles.plot];
  all_handles.axis = [all_handles.axis, handles.axis];

  % apply each plot's decoration separately
  decorate(a_plot.plots{plot_num});
end

handles = all_handles;
