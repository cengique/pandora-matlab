function a_plot = plotfICurveStats(p_bundle, title_str, props)

% plotfICurveStats - Generates a f-I curve mean-std plot of physiology DB.
%
% Usage:
% a_plot = plotfICurveStats(p_bundle, title_str, props)
%
% Description:
%
%   Parameters:
%	p_bundle: A physiol_bundle object.
%	title_str: (Optional) String to append to plot title.
%	props: A structure with any optional properties.
%	  quiet: if given, no title is produced
%	  (passed to plot_superpose)
%
%   Returns:
%	a_plot: An f-I curve plot.
%
%   Example:
% >> plotFigure(plotfICurveStats(pbundle));
%
% See also: dataset_db_bundle/plotfICurve, plot_abstract, plot_superpose
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/06/16

if ~ exist('props')
  props = struct([]);
end

if ~ exist('title_str')
  title_str = '';
end

if isfield(props, 'quiet')
  caption = title_str;
else
  caption = ['mean and STD of ' p_bundle.joined_control_db.id title_str];
end

%# TODO: get these from uniqueValues
curve_pAvals = [0 40 100 200];
curve_tests = {'IniSpontSpikeRateISI_0pA', 'PulseIni100msSpikeRateISI_D40pA', ...
	       'PulseIni100msSpikeRateISI_D100pA', 'PulseIni100msSpikeRateISI_D200pA'};
curve_labels = {'current pulse [pA]', 'firing rate [Hz]'};

a_plot = ...
    plotYTests(statsMeanStd(p_bundle.joined_control_db), ...
	       curve_pAvals, curve_tests, curve_labels, '', caption, [], ...
	       struct('quiet', 1, 'legendLocation', 'NorthWest'));
