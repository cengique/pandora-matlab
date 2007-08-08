function a_cluster_db = kmeansCluster(db, num_clusters, props)

% kmeansCluster - Generates a database of cluster centers obtained from a k-means cluster analysis with the command kmeans.
%
% Usage:
% a_cluster_db = kmeansCluster(db, num_clusters, props)
%
% Description:
%
%   Parameters:
%	db: A tests_db object.
%	num_clusters: Number of clusters to form.
%	props: A structure with any optional properties.
%	  DistanceMeasure: Choose one appropriate for kmeans.
%		
%   Returns:
%	a_cluster_db: A tests_db where each row is a cluster center.
%	a_hist_db: histogram_db showing cluster membership from original db.
%	idx: Cluster indices of each row or original db.
%	sum_distances: Quality of clustering indicated by total distance from
%			centroid for each cluster.
%
% See also: tests_db, histogram_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/04/06

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

if ~ exist('props')
  props = struct([]);
end

if isfield(props, 'DistanceMeasure')
  distance_measure = props.DistanceMeasure;
else
  distance_measure = 'correlation';
end

[idx, clusters, sum_distances] = kmeans(get(db, 'data'), num_clusters, ...
					'distance', distance_measure, ...
					'start', 'cluster', ...
					'display', 'iter');

a_cluster_db = cluster_db(clusters, fieldnames(get(db, 'col_idx')), db, idx, ...
			[ num2str(num_clusters) ' clusters of ' get(db, 'id') ], ...
			mergeStructs(props, ...
				     struct('sumDistances', sum_distances, ...
					    'distanceMeasure', distance_measure)));


