function a_plot = plotQuality(a_cluster_db, title_str)

% plotQuality - Creates a plot_abstract of the silhouette plot showing the clustering quality.
%
% Usage:
% a_plot = plotQuality(a_cluster_db, title_str)
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
% See also: plot_abstract, plotFigure, silhouette
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/04/08

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

tests_props = get(a_cluster_db, 'props');

if isfield(tests_props, 'DistanceMeasure')
  distance_measure = tests_props.DistanceMeasure;
else
  distance_measure = 'correlation';
end

if ~ exist('title_str')
  title_str = '';
end

if isfield(tests_props, 'quiet') && tests_props.quiet == 1
  title_str = [ 'silhouette plot' title_str ];
else 
  title_str = [ get(a_tests_db, 'id') ', silhouette plot' title_str ];
end

a_plot = ...
    plot_abstract({ get(a_cluster_db.orig_db, 'data'), a_cluster_db.cluster_idx, ...
		   distance_measure }, ...
		  {'quality', 'cluster'}, ...
		  title_str, {}, 'silhouette');
