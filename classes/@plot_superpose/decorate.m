function handles = decorate(a_plot)

% decorate - Places decorations using the first plot of the superposed plots.
%
% Usage:
% handles = decorate(a_plot)
%
% Description:
%
%   Parameters:
%	a_plot: A plot_abstract object, or a subclass object.
%		
%   Returns:
%	handles: Handles of graphical objects drawn.
%
% See also: plot_abstract, plot_abstract/plot
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/04/11

%# Get props from plot_superpose
to_plot = set(a_plot, 'props', ...
	      mergeStructs(get(a_plot, 'props'), get(a_plot.plots{1}, 'props')));

handles = decorate(to_plot.plot_abstract);
