function handles = decorate(a_plot)

% decorate - No additional decorations for stacked plots.
%
% Usage:
% a_histogram_db = decorate(a_plot)
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
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/04

handles = struct([]);

%# Put a title?
%#handles.title = title(get(a_plot, 'title'));
