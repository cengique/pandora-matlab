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
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/04/08

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

if ~ exist('title_str')
  title_str = '';
end

a_cluster_db = setProp(a_cluster_db, 'quiet', 1)

%# If PCA or cluster
if size(a_cluster_db.cluster_idx, 2) > 1
  score_plots = {};
  for plot_num = 1:floor(dbsize(a_cluster_db, 1)/2)
    pc1 = 2*plot_num - 1;
    pc2 = 2*plot_num;
    score_plots{plot_num} = ...
	plot_abstract({a_cluster_db.cluster_idx(:, pc1), ...
		       a_cluster_db.cluster_idx(:, pc2), 'x'}, ...
		      {['Prin. comp. ' num2str(pc1)], ...
		       ['Prin. comp. ' num2str(pc2)]}, 'PC scores', {}, 'plot');
  end
  cluster_props = get(a_cluster_db, 'props');
  a_plot = ...
      plot_stack({plotrows(a_cluster_db, [], 'y'), ...
		  plot_stack({ score_plots{:}, ...
			      plot_abstract({cluster_props.latent}, ...
					    {'Prin. comp.', 'Latent'}, ...
					    'PC variances', {}, 'bar') }, ...
			     [], 'y', '') }, [], 'x', ...
		 [get(a_cluster_db, 'id') title_str ]);
else
  a_plot = ...
      plot_stack({plotrows(a_cluster_db, [], 'y'), ...
		  plot_stack({ plotHist(a_cluster_db), plotQuality(a_cluster_db) }, ...
			     [], 'y', '') }, [], 'x', ...
		 [get(a_cluster_db, 'id') title_str ]);
end
