function a_plot = plotfICurve(a_bundle, an_index, props)

% plotfICurve - Generates a f-I curve doc_plot for neuron at given an_index in a_bundle.
%
% Usage:
% a_plot = plotfICurve(a_bundle, trial_num, props)
%
% Description:
%
%   Parameters:
%	a_bundle: A dataset_db_bundle object.
%	an_index: An index with which to address the a_bundle.
%	props: A structure with any optional properties.
%	  shortCaption: This appears in the figure caption.
%	  plotMStats: If set, add the a_bundle stats plot.
%	  captionToStats: Use this as its legend label. 
%	  quiet: if given, no title is produced
%	  (passed to plot_superpose)
%
%   Returns:
%	a_plot: A plot_superpose that contains a f-I curve plot.
%
%   Example:
% >> a_p = plotfICurve(r, 1);
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
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props')
  props = struct([]);
end

neuron_name = getNeuronLabel(a_bundle, an_index);

if isfield(props, 'shortCaption')
  short_caption = props.shortCaption;
else
  short_caption = ...
      ['f-I curves of ' neuron_name ' in ' ...
       get(get(a_bundle, 'joined_db'), 'id') '.' ];
end

if isfield(props, 'quiet')
  caption = '';
else
  caption = [ short_caption ];
end

% Get unique current values  ([0 40 100 200])
curve_pAvals = unique(transpose(get(onlyRowsTests(get(a_bundle, 'db'), ':', 'pAcip'), 'data')));

% only get non-negative currents
curve_pAvals = curve_pAvals(curve_pAvals >= 0);

curve_tests = {};
for pAval=curve_pAvals
  switch pAval
    case 0
      curve_tests = { curve_tests{:}, 'IniSpontSpikeRateISI_0pA'};
    case 40
      curve_tests = { curve_tests{:}, 'PulseIni100msSpikeRateISI_D40pA'};
    case 100
      curve_tests = { curve_tests{:}, 'PulseIni100msSpikeRateISI_D100pA'};
    case 200
      curve_tests = { curve_tests{:}, 'PulseIni100msSpikeRateISI_D200pA'};
    otherwise
      error([ 'Unrecognized current value: ' num2str(pAval) ]);
  end
end

curve_labels = {'current pulse [pA]', 'firing rate [Hz]'};

joined_db = get(a_bundle, 'joined_db');

a_plot = ...
    plotYTests(joined_db(getNeuronRowIndex(a_bundle, an_index), :), ...
	       curve_pAvals, curve_tests, curve_labels, ...
	       'current vs. rate', neuron_name, ...
	       [], mergeStructs(props, struct('quiet', 1)));
