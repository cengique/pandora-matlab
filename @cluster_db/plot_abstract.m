function a_plot = plot_abstract(a_cluster_db, title_str)

% plot_abstract - Creates a vertical plot_stack of silhouette and membership histograms for the clusters.
%
% Usage:
% a_plot = plot_abstract(a_cluster_db, title_str)
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
% See also: cluster_db/plotQuality, cluster_db/plotHist
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/04/08

if ~ exist('title_str')
  title_str = '';
end

a_plot = ...
    plot_stack({plotrows(a_cluster_db, [], 'y'), ...
		plot_stack({ plotHist(a_cluster_db), plotQuality(a_cluster_db) }, ...
			   [], 'y', '') }, [], 'x', ...
	       [get(a_cluster_db, 'id') title_str ]);
