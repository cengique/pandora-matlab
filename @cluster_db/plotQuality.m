function a_plot = plotQuality(a_cluster_db, props)

% plotQuality - Creates a plot_abstract of the silhouette plot showing the clustering quality.
%
% Usage:
% a_plot = plotQuality(a_cluster_db)
%
% Description:
%
%   Parameters:
%	a_cluster_db: A cluster_db object.
%		
%   Returns:
%	a_plot: A plot_abstract object that can be plotted.
%
% See also: plot_abstract, plotFigure, silhouette
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/04/08

if ~ exist('props')
  props = struct([]);
end

if isfield(props, 'DistanceMeasure')
  distance_measure = props.DistanceMeasure;
else
  distance_measure = 'correlation';
end

a_plot = ...
    plot_abstract({ get(a_cluster_db.orig_db, 'data'), a_cluster_db.cluster_idx, ...
		   distance_measure }, ...
		  {'quality', 'cluster'}, ...
		  [ get(a_cluster_db, 'id') ', silhouette plot'], {}, 'silhouette', ...
		  props);
