function plots = plotCompareRanks(m_bundle, p_bundle, a_ranked_db, ranks, props)

% plotCompareRanks - Generates a plots of given ranks from the ranked_bundle.
%
% Usage:
% plots = plotCompareRanks(m_bundle, p_bundle, a_ranked_db, ranks, props)
%
% Description:
%
%   Parameters:
%	m_bundle: A model_ct_bundle object.
%	p_bundle: A dataset_db_bundle object that originated the criterion.
%	a_ranked_db: A ranked_db generated from ranking m_bundle.
%	ranks: Vector of rank indices for which to generate the plots.
%	props: A structure with any optional properties.
%
%   Returns:
%	plots: A structure that contains the joined_db, and the plot vectors 
%	  trace_d100_plots and trace_h100_plots.
%
%   Example:
% >> plots = plotCompareRanks(r, 1:10);
% >> plotFigure(plots.trace_d100_plots(1), 'The best matching +100 pA CIP trace');
%
% See also: 
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/01/16

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

joined_db = joinOriginal(a_ranked_db);

ranked_num_rows = dbsize(joined_db, 1);

if isempty(ranks)
  ranks = 1:6;
end

num_plots = length(ranks);

%# LaTeX likes '_' to be '\_' 
a_db_id = strrep(lower(get(a_ranked_db.orig_db, 'id')), '_', '\_');
crit_db_id = strrep(lower(get(a_ranked_db.crit_db, 'id')), '_', '\_');

if ranked_num_rows > 0

  %# Display raw data traces from dataset
  plots.crit_trace_d100 = ctFromRows(p_bundle, a_ranked_db.crit_db, 100);
  plots.crit_trace_h100 = ctFromRows(p_bundle, a_ranked_db.crit_db, -100);

  if isempty(plots.crit_trace_h100) || isempty(plots.crit_trace_d100)
    error(['Cannot find one of 100 or -100 pA cip traces in ' crit_db_id '.']);
  end

  crit_trace_id = strrep(get(plots.crit_trace_d100(1), 'id'), '_', '\_');

  trace_d100_plots = cell(1, num_plots);
  trace_h100_plots = cell(1, num_plots);

  for plot_num=1:num_plots
    rank_num = ranks(plot_num);
    trial_num = get(onlyRowsTests(joined_db, rank_num , 'trial'), 'data');
    if plot_num > 1
      sup_props = struct('noLegends', 1);
      crit_traces = 1;
    else
      sup_props = struct;
      crit_traces = ':';
    end
    trace_d100_plots{plot_num} = ...
	superposePlots([plotData(ctFromRows(m_bundle, trial_num, 100)), ...
			plotData(plots.crit_trace_d100(crit_traces))], {}, ...
		       ['Rank ' num2str(rank_num) ', t' num2str(trial_num)], ...
		       'plot', sup_props);
    trace_h100_plots{plot_num} = ...
	superposePlots([plotData(ctFromRows(m_bundle, trial_num, -100)), ...
			plotData(plots.crit_trace_h100(crit_traces))], {}, '', ...
		       'plot', sup_props);
  end
  
  plots.crit_trace_id = crit_trace_id;
  plots.joined_db = joined_db;
  plots.trace_d100_plots = trace_d100_plots;
  plots.trace_h100_plots = trace_h100_plots;
else
  plots = struct([]);
end
