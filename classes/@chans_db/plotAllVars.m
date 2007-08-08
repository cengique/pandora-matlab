function a_plot = plotAllVars(a_chans_db, id, props)

% plotAllVars - Plot all channel variables by grouping activation and time constant curves per channel.
%
% Usage: 
% a_plot = plotAllVars(a_chans_db, title_str, props)
%
% Description:
%
%   Parameters:
%	a_chans_db: A chans_db describing channel variables.
%	id: String that identify the source of the tables structure.
%	props: A structure with any optional properties.
%	  (rest passed to plot_abstract.)
%
%   Returns:
%	a_plot: A plot_abstract object that can be visualized.
%
% See also: trace, trace/plot, plot_abstract
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2007/03/05

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

if ~ exist('props')
  props = struct;
end

chan_props = get(a_chans_db, 'props');

chan_names = chan_props.chan_names;
all_names = getColNames(a_chans_db);
db_id = get(a_chans_db, 'id');

% cannot guess length if DB is filtered
all_plots = plot_abstract;

chan_num = 1;
% go thru all channels in tables
for chan_name = chan_names
  chan_name = chan_name{1};

  % group minf gates and get their product
  inf_gates = all_names(~cellfun(@isempty, regexp(all_names, [ chan_name '_._minf' ], 'match')));
  tau_gates = all_names(~cellfun(@isempty, regexp(all_names, [ chan_name ...
                      '_._tau' ], 'match')));
  
  if ~ isempty(inf_gates)
    % group minf and tau gates into separate plots
    all_plots(chan_num * 2 - 1) = plotGateVars(a_chans_db, chan_name, inf_gates);
    all_plots(chan_num * 2) = plotGateVars(a_chans_db, chan_name, tau_gates);
  
    %   create plot with act-inact curves superposed, and vice versa for tau

    %   separate plot for each channel found
    chan_num = chan_num + 1;
  end
end

% matrix plot it
a_plot = matrixPlots(all_plots, {}, [ db_id ' channel tables' ], ...
		     struct('titlesPos', 'all', 'xLabelsPos', 'bottom', 'xTicksPos', 'bottom'));
