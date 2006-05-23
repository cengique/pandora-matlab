function ranges = axis(a_plot)

% axis - Returns the maximal axis ranges according to superposed subplots.
%
% Usage:
% ranges = axis(a_plot)
%
% Description:
%
%   Parameters:
%	a_plot: A plot_abstract object, or a subclass object.
%		
%   Returns:
%	ranges: The ranges as a vector in the same way 'axis' would return.
%
% See also: plot_abstract, plot_abstract/plot
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/05/22

num_plots = length(a_plot.plots);

ranges = [];
for plot_num=1:num_plots
  ranges = growRange([ranges; axis(a_plot.plots{plot_num})]);
end

