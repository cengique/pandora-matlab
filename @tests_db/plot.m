function h = plot(a_tests_db, title_str)

% plot - Generic method to plot a tests_db or a subclass. Requires a 
%	plot_abstract method to be defined for this object.
%
% Usage:
% h = plot(a_tests_db, title_str)
%
% Description:
%
%   Parameters:
%	a_tests_db: A histogram_db object.
%	title_str: (Optional) String to append to plot title.
%		
%   Returns:
%	h: The figure handle created.
%
% See also: plot_abstract, plotFigure
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/06

if ~ exist('title_str')
  title_str = '';
end

h = plotFigure(plot_abstract(a_tests_db, title_str));
