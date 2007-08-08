function a_plot = plotComparefICurve(m_bundle, m_trial, to_bundle, to_index, props)

% plotComparefICurve - Generates a f-I curve doc_plot comparing m_trial and to_index.
%
% Usage:
% a_plot = plotComparefICurve(m_bundle, m_trial, to_bundle, to_index, props)
%
% Description:
%   Note that this is not a general method. to_bundle should have been able to accept
% any type of bundle. Most probably this method is redundant and deprecated.
%
%   Parameters:
%	m_bundle: A model_ct_bundle object.
%	m_trial: Trial number of model.
%	to_bundle: A physiol_bundle object.
%	to_index: TracesetIndex of neuron.
%	props: A structure with any optional properties.
%	  shortCaption: This appears in the figure caption.
%	  plotMStats: If set, add the m_bundle stats plot.
%	  plotToStats: If set, add the to_bundle stats plot.
%	  captionToStats: Use this as its legend label. 
%	  quiet: if given, no title is produced
%	  (passed to plot_superpose)
%
%   Returns:
%	a_plot: A plot_superpose that contains a f-I curve plot.
%
%   Example:
% >> a_p = plotComparefICurve(r, 1);
% >> plotFigure(a_p, 'The f-I curve of best matching model');
%
% See also: plot_abstract, plot_superpose
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/01/16

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

if ~ exist('props')
  props = struct([]);
end

if isfield(props, 'shortCaption')
  short_caption = props.shortCaption;
else
  short_caption = ...
      ['f-I curves of trial ' num2str(m_trial) ' in ' get(get(m_bundle, 'joined_db'), 'id') ...
       ' vs. index ' num2str(to_index) ' in ' get(to_bundle.joined_db, 'id') '.' ];
end

if isfield(props, 'quiet')
  caption = '';
else
  caption = [ short_caption ];
end

%# TODO: get these from uniqueValues
curve_pAvals = [0 40 100 200];
curve_tests = {'IniSpontSpikeRateISI_0pA', 'PulseIni100msSpikeRateISI_D40pA', ...
	       'PulseIni100msSpikeRateISI_D100pA', 'PulseIni100msSpikeRateISI_D200pA'};
curve_labels = {'current pulse [pA]', 'firing rate [Hz]'};


joined_db = get(m_bundle, 'joined_db');

neuron_name = properTeXLabel(get(getItem(to_bundle.dataset, to_index), 'id'));

%# to_bundle part is still a little hazy
plots_all = {};
plots_all = ...
    {plots_all{:}, ...
     plotYTests(joined_db(joined_db(:, 'trial') == m_trial, :), curve_pAvals, curve_tests, ...
		curve_labels, 'frequency vs. current', [ 'model (t' num2str(m_trial) ')'], ...
		[], struct('axisLimits', [0 200 0 100], 'quiet', 1)), ...
     plotYTests(to_bundle.joined_db(to_bundle.joined_db(:, 'TracesetIndex') == to_index, :), ...
		curve_pAvals, curve_tests, ...
		curve_labels, '', [ neuron_name ' (avg)'], ...
		[], struct('quiet', 1))};

if isfield(props, 'plotToStats')
  if isfield(props, 'captionToStats')
    stats_caption = props.captionToStats;
  else
    stats_caption = ['mean and STD of ' to_bundle.joined_db.id];
  end

  plots_all = {plots_all{:}, ...
	       plotYTests(statsMeanStd(to_bundle.joined_db), ...
			  curve_pAvals, curve_tests, curve_labels, ...
			  '', stats_caption, [], ...
			  struct('quiet', 1))};
end

a_plot = plot_superpose(plots_all, {}, caption, ...
			mergeStructs(props, struct('legendLocation', 'NorthWest')));
