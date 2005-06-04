function handles = plot(a_plot, layout_axis)

% plot - Draws this plot in the current axis.
%
% Usage:
% handles = plot(a_plot, layout_axis)
%
% Description:
%
%   Parameters:
%	a_plot: A plot_abstract object, or a subclass object.
%	layout_axis: The axis position to layout this plot (Optional). 
%		
%   Returns:
%	handles: Handles of graphical objects drawn.
%
% See also: plot_abstract
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/22

%# Fixed size for ticks and labels
decosize = 0.04;

%# TODO: save the axis handle!
if exist('layout_axis')
  left_side = layout_axis(1);
  bottom_side = layout_axis(2);
  width = layout_axis(3);
  height = layout_axis(4);
else
  [ left_side bottom_side width height ] = deal(0, 0, 1, 1);
end

a_plot_props = get(a_plot, 'props');
%# Adjust the axis according to decorations
if ~isfield(a_plot_props, 'noXLabel') || a_plot_props.noXLabel == 0
  y_strut = decosize / 2;
  bottom_side = bottom_side + y_strut;
  height = height - y_strut;
end

if ~isfield(a_plot_props, 'XTickLabel') || ~isempty(a_plot_props.XTickLabel)
  y_strut = decosize;
  bottom_side = bottom_side + y_strut;
  height = height - y_strut;
end

if ~isfield(a_plot_props, 'noYLabel') || a_plot_props.noYLabel == 0
  x_strut = decosize / 2;
  left_side = left_side + x_strut;
  width = width - x_strut;
end

if ~isfield(a_plot_props, 'YTickLabel') || ~isempty(a_plot_props.YTickLabel)
  x_strut = decosize;
  left_side = left_side + x_strut;
  width = width - x_strut;
end

axes('position', [left_side bottom_side width height]);

%# Run the plot command
if strcmp(a_plot.command, 'boxplot') || strcmp(a_plot.command, 'boxplotp')
  feval(a_plot.command, a_plot.data{:});
  ph = []; %# boxplot returns no handle???
elseif strcmp(a_plot.command, 'silhouette')
  %# silhouette plot requires two return values
  [silh, ph] = feval(a_plot.command, a_plot.data{:});
else
  ph = feval(a_plot.command, a_plot.data{:});
end

%# Add titles, etc. (Not here! see plotFigure)
%#handles = decorate(a_plot);

%# Add plot handle
handles.plot = ph;
