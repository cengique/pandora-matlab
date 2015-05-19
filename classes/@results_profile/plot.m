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
%       props: Optional properties passed to plot_abstract.
%		
%   Returns:
%	h: The figure handle created.
%
% See also: plot_abstract, plotFigure
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/06

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('title_str', 'var')
  title_str = '';
end

props = defaultValue('props', struct);

h = plotFigure(plot_abstract(a_tests_db, title_str, props));
