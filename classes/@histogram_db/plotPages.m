function a_plot = plotPages(a_hist_db, title_str, props)

% plotPages - Generates a plot containing subplots from each page of histograms.
%
% Usage:
% a_plot = plotPages(a_hist_db, title_str, props)
%
% Description:
%   For each page of the histogram, a histogram is placed in a subplot.
%
%   Parameters:
%	a_hist_db: A histogram_db object.
%	title_str: (Optional) String to append to plot title.
%	props: A structure with any optional properties, passed to plot_stack.
%	  an_orient: Stack orientation. One of 'x', or 'y' (Default='y'; vertical).
%	  quiet: If 1, only display given title_str.
%		
%   Returns:
%	a_plot: A object of plot_abstract or one of its subclasses.
%
% See also: plotPages, plot_simple
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/04

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Defaults
if ~ exist('title_str')
  title_str = '';
end

if ~ exist('props')
  props = struct([]);
end

if ~ isfield(props, 'an_orient')
  props.an_orient = 'y'; % vertical
end

num_pages = dbsize(a_hist_db.tests_db, 3);
pages=(1:num_pages)';
subplots = cell(num_pages, 1);

ranges = [];
for page_num=pages'
  % use default histogram plot
  a_plot = plot_abstract(onlyRowsTests(a_hist_db, ':', ':', ...
				       page_num));
  % Add a page identification label on the x-axis label
  a_hist_db_props = get(a_hist_db, 'props');
  if isfield(a_hist_db_props, 'pageNames')
    page_names = a_hist_db_props.pageNames;
    axis_labels = get(a_plot, 'axis_labels');
    axis_labels{1} = [ axis_labels{1} ', ' page_names{page_num} ];
    a_plot = set(a_plot, 'axis_labels', axis_labels);
  end
  % Calculate the maximal axis range
  if isempty(ranges)
    ranges = axis(a_plot);
  else
    ranges = growRange([ranges; axis(a_plot)]);
  end
  subplots{page_num} = a_plot;
end

the_title = get(subplots{1}, 'title');
if isfield(props, 'quiet')
  if ~ isempty(title_str)
    the_title = title_str;
  end
else
  if ~ isempty(title_str)
    the_title = [ the_title title_str ];
  end
end

a_plot = plot_stack(subplots, ranges, props.an_orient, the_title, ...
		    struct('titlesPos', 'none'));
