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
  titleheight = 0.03;
end
border = 0.1;
plot(a_plot, [border/2, border/2, ...
	      (1 - border), (1-border - titleheight)]);
decorate(a_plot);
