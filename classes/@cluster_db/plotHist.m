function a_plot = plotHist(a_cluster_db, title_str)

% plotHist - Creates a histogram plot showing the clustering memberships.
%
% Usage:
% a_plot = plotHist(a_cluster_db, title_str)
%
% Description:
%
%   Parameters:
%	a_cluster_db: A cluster_db object.
%	title_str: (Optional) String to append to plot title.
%		
%   Returns:
%	a_plot: A plot_abstract object that can be plotted.
%
% See also: plot_abstract, plotFigure, histogram_db, histogram_db/plot_abstract
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/04/08

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('title_str')
  title_str = '';
end

tests_props = get(a_cluster_db, 'props');
if isfield(tests_props, 'quiet') && tests_props.quiet == 1
  title_str = [ 'memberships' title_str ];
else 
  title_str = ['memberships to ' get(a_cluster_db, 'id') title_str ];
end

bins = 1:dbsize(a_cluster_db, 1);

% TODO: have the following in a separate method?
a_hist_db = histogram_db('cluster', bins, hist(a_cluster_db.cluster_idx, bins), ...
			 title_str);

a_plot = plot_abstract(a_hist_db);
