function handles = plot(a_plot)

% plot - Draws this plot in the current axis.
%
% Usage:
% handles = plot(a_plot)
%
% Description:
%
%   Parameters:
%	a_plot: A plot_abstract object, or a subclass object.
%		
%   Returns:
%	handles: Handles of graphical objects drawn.
%
% See also: plot_abstract
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/22

%# Run the plot command
ph = feval(a_plot.command, a_plot.data{:});

%# Add titles, etc.
handles = decorate(a_plot);

%# Add plot handle
handles.plot = ph;
