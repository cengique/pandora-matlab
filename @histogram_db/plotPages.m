function a_plot = plotPages(a_hist_db, command, an_orient)

% plotPages - Generates a plot containing subplots of histograms in
%		each page.
%
% Usage:
% a_plot = plotPages(a_hist_db, command, an_orient)
%
% Description:
%   For each page of the histogram, a histogram is placed in a subplot.
%
%   Parameters:
%	a_hist_db: A histogram_db object.
%	command: Plot command (Optional, default='bar')
%	an_orient: Stack orientation. One of 'x', 'y', or 'z'.
%		
%   Returns:
%	a_plot: A object of plot_abstract or one of its subclasses.
%
% See also: plotPages, plot_simple
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/04

%# Defaults
if ~ exist('an_orient')
  an_orient = 'y'; %# vertical
end

if ~ exist('command')
  command = 'bar';
end

num_pages = size(a_hist_db.tests_db.data, 3);
pages=(1:num_pages)';
subplots = cell(num_pages, 1);

for page_num=pages'
  a_plot = plot_abstract(onlyRowsTests(a_hist_db, ':', ':', ...
				       page_num));
  %# Add a page identification label on the x-axis label
  if isfield(a_hist_db.props, 'pageNames')
    page_names = a_hist_db.props.pageNames;
    axis_labels = get(a_plot, 'axis_labels');
    axis_labels{1} = [ axis_labels{1} ', ' page_names{page_num} ];
    a_plot = set(a_plot, 'axis_labels', axis_labels)
  end
  subplots{page_num} = a_plot;
end

a_plot = plot_stack(subplots, [], an_orient, '', struct('titlesPos', 'top'));
