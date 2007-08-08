function a_plot = plotAllInf(a_chans_db, title_str, props)

% plotAllInf - Plots the steady-state (infinity) response of all channels.
%
% Usage: 
% a_plot = plotAllInf(a_chans_db, title_str, props)
%
% Description:
%
%   Parameters:
%	a_chans_db: a chans_db
%	title_str: Plot title.
%	props: A structure with any optional properties.
%	  (rest passed to matrixPlots.)
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

%all_plots = repmat(plot_abstract, 1, length(chan_names));
all_plots = plot_abstract;

chan_num = 1;
% go thru all channels in tables
for chan_name = chan_names
  chan_name = chan_name{1};
  
  % group minf gates and get their product
  inf_gates = all_names(~cellfun(@isempty, regexp(all_names, [ chan_name '_._minf' ], 'match')));
  
  if ~ isempty(inf_gates)
    all_plots(chan_num) = plotInf(chan_name, inf_gates);
  
    %   separate plot for each gate
    chan_num = chan_num + 1;
  end

end

% matrix plot it
a_plot = ...
    matrixPlots(all_plots, {}, [ db_id ' channel inf curves' ], ...
                mergeStructs(props, ...
                             struct('titlesPos', 'all', 'xLabelsPos', 'bottom', ...
                                    'xTicksPos', 'bottom', ...
                                    'axisLimits', [-0.1 0.05 NaN NaN])));


end