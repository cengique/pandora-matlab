function h = plot(a_tests_db)

% plot - Generic method to plot a tests_db or a subclass. Requires a 
%	plot_abstract method to be defined for this object.
%
% Usage:
% h = plot(a_tests_db)
%
% Description:
%
%   Parameters:
%	a_tests_db: A histogram_db object.
%		
%   Returns:
%	h: The figure handle created.
%
% See also: plot_abstract, plotFigure
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/06

h = plotFigure(plot_abstract(a_tests_db));
