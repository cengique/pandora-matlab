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
set(handle, 'Name', get(a_plot, 'title'));
border = 0.05;
plot(a_plot, [border/2 + 0.05 border/2 + 0.05 (1-border-0.05) (1-border-0.05)]);
decorate(a_plot);
