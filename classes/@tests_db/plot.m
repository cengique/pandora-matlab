function h = plot(a_tests_db, title_str, props)

% plot - Generic method to plot a tests_db or a subclass. Requires a 
%	plot_abstract method to be defined for this object.
%
% Usage:
% h = plot(a_tests_db, title_str, props)
%
% Description:
%
%   Parameters:
%	a_tests_db: A histogram_db object.
%	title_str: (Optional) String to append to plot title.
%	props: A structure with any optional properties, passed to plot_abstract.
%		
%   Returns:
%	h: The figure handle created.
%
% See also: plot_abstract, plotFigure
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/06

if ~ exist('title_str')
  title_str = '';
end

if ~ exist('props')
  props = struct;
end

h = plotFigure(plot_abstract(a_tests_db, title_str, props));
