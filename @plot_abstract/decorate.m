function handles = decorate(a_plot)

% decorate - Draws this plot in the current axis.
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
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/22

%# Run the plot command
th = title(a_plot.title);
xh = xlabel(a_plot.axis_labels{1});
yh = ylabel(a_plot.axis_labels{2});
%# Z-axis?
if (length(a_plot.legend) > 0)
  lh = legend(a_plot.legend);
else
  lh = [];
end

handles = struct('title', th, 'axis_labels', [xh, yh], 'legend', lh);