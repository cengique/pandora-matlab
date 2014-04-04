function a_p = plotScatter(a_db, test1, test2, title_str, short_title, props)

% plotScatter - Superpose scatter plots for each page of the database of the given two tests.
%
% Usage:
% a_p = plotScatter(a_db, test1, test2, title_str, short_title, props)
%
%   Parameters:
%	a_db: A tests_3D_db object.
%	test1, test2: X & Y variables.
%	title_str: (Optional) A string to be concatenated to the title.
%	short_title: (Optional) Few words that may appear in legends of multiplot.
%	props: A structure with any optional properties.
%	  LineStyle: Plot line style to use. (default: 'x')
%	  Regress: If exists, use these props for plotting the linear regression.
%	  quiet: If 1, don't include database name on title.
%	  (all passed to tests_db/plotScatter)
%		
%   Returns:
%	a_p: A plot_abstract.
%
% Description:
%   If 'warning on verbose' is issued before this, it will display
% regression statistics: R^2, F, p, and the error variance.
%
% See also: tests_db/plotScatter
%
% $Id: plotScatter.m 1335 2012-04-19 18:04:32Z cengique $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/09/29

% Copyright (c) 2007-2014 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

a_plots = repmat(plot_abstract, 1, dbsize(a_db, 3));

for page_num=1:dbsize(a_db, 3)
  a_plots(page_num) = ...
      plotScatter(get(onlyRowsTests(a_db, ':', ':', page_num), ...
                      'tests_db'), test1, test2, ...
                  title_str, short_title, props);
end

a_p = superposePlots(a_plots);
