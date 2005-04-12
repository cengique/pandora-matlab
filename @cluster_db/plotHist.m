function a_plot = plotHist(a_cluster_db, props)

% plotHist - Creates a plot_abstract of the silhouette plot showing the clustering quality.
%
% Usage:
% a_plot = plotHist(a_cluster_db)
%
% Description:
%
%   Parameters:
%	a_cluster_db: A cluster_db object.
%		
%   Returns:
%	a_plot: A plot_abstract object that can be plotted.
%
% See also: plot_abstract, plotFigure, histogram_db, histogram_db/plot_abstract
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/04/08

if ~ exist('props')
  props = struct([]);
end

bins = 1:dbsize(a_cluster_db, 1);

%# TODO: have the following in a separate method?
a_hist_db = histogram_db('cluster', bins, hist(a_cluster_db.cluster_idx, bins), ...
			 ['memberships to ' get(a_cluster_db, 'id') ]);

a_plot = plot_abstract(a_hist_db);
