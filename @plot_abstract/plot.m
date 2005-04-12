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

%# TODO: save the axis handle!
if exist('layout_axis')
  axes('position', layout_axis);
end

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
