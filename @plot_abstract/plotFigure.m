function handle = plotFigure(a_plot)

% plotFigure - Draws this plot alone in a new figure window.
%
% Usage:
% handle = plotFigure(a_plot)
%
% Description:
%
%   Parameters:
%	a_plot: A plot_abstract object, or a subclass object.
%		
%   Returns:
%	handle: Handle of new figure.
%
% See also: plot_abstract, plot_abstract/plot, plot_abstract/decorate
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/22

handle = figure;
title = get(a_plot, 'title');
set(handle, 'Name', title);

if isempty(title)
  titleheight = 0;
else
  titleheight = 0.05;
end

if isfield(a_plot.props, 'border')
  border = a_plot.props.border;
else
  border = 0.15;
end

axis_labels = get(a_plot, 'axis_labels');
if length(axis_labels) < 1 || isempty(axis_labels(1))
  left_border = 0;
else
  left_border = border / 2;
end

if length(axis_labels) < 2 || isempty(axis_labels(2))
  bottom_border = 0;
else
  bottom_border = border / 2;
end

%# Put default borders: less border for top title, no border on right side
plot(a_plot, [left_border, bottom_border, ...
	      1, (1 - titleheight)]);
decorate(a_plot);
