function a_plot = plotBox(a_tests_db, title_str, props)

% plotBox - Creates a boxplot from each column in tests_db in separate axes.
%
% Usage:
% a_plot = plotBox(a_tests_db, title_str, props)
%
% Description:
%
%   Parameters:
%	a_tests_db: A tests_db object.
%	title_str: Optional title.
%	props: A structure with any optional properties.
%	  putLabels: Put special column name labels.
%	  notch: If 1, put notches on boxplots (default=1).
%		
%   Returns:
%	a_plot: A plot_abstract object that can be plotted.
%
% See also: plot_abstract, plotFigure
%
% $Id: plotBox.m 896 2007-12-17 18:48:55Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2008/01/16

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

if ~ exist('title_str', 'var')
  title_str = '';
end

if isfield(props, 'notch')
   notch = props.notch;
else
   notch = 1;
end

if ~ exist('sym')
  sym = '';
end

if ~ exist('vert')
  vert = 1;
end

if ~ exist('whis')
  whis = 1.5;
end

if dbsize(a_tests_db, 2) > 1 
  error('Plotting multiple columns at the same time not implemented!');
end

col_name = getColNames(a_tests_db);

if isfield(props, 'quiet')
  all_title = properTeXLabel(title_str);
else
  all_title = ...
      properTeXLabel(['Distributions from ' lower(get(a_tests_db, 'id')) title_str ]);
end

a_plot = ...
    plot_abstract({get(a_tests_db, 'data'), ...
                   notch, sym, vert, whis, struct('nooutliers', 1)}, ...
                  {'', properTeXLabel(col_name)}, ...
                  all_title, {}, 'boxplotp', props); % mergeStructs(, struct)('tightLimits', 1)
