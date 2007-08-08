function a_subplot = plotInf(a_chans_db, chan_name, gate_subnames, props)

% plotInf - Plot the product of minf variables and the gmax of the given channel.
%
% Usage: 
% a_plot = plotInf(a_chans_db, chan_name, gate_subnames)
%
% Description:
%
%   Parameters:
%	a_chans_db: A chans_db describing channel variables.
%	chan_name: Name of channel that make up the stem of variable
%		names.
% 	gate_subnames: Gate names of the channel.
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
% Author: Cengiz Gunay <cgunay@emory.edu>, 2007/07/01

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

  if ~ exist('props', 'var')
    props = struct;
  end

  inf_name = [ chan_name '_inf' ];
  db_id = get(a_chans_db, 'id');

  % it sucks that I need a for loop for getting multiple values out of a
  % structure 
  powers = [];
  
  for power_name = strrep(gate_subnames, '_minf', 'power')
    power_name = power_name{1};
    powers = [powers, a_chans_db.channel_info.(power_name)];
  end
  
  % recalculate channel conductance by inf values, powers and Gbar
  a_chans_db = ...
      addColumns(a_chans_db, { inf_name }, ...
                 a_chans_db.channel_info.([ chan_name '_Gbar' ]) .* ...
                 prod(get(onlyRowsTests(a_chans_db, ':', gate_subnames), ...
                          'data') .^ ( ones(dbsize(a_chans_db, 1), 1) * powers ), 2) );

  a_subplot = ...
      plotScatter(a_chans_db, [ chan_name '_x' ], inf_name, [ strrep(chan_name, '_', ' ') ], ...
                  strrep([ db_id ' ' inf_name ], '_', ' '), ...
                  mergeStructs(props, struct('LineStyle', '-', 'quiet', 1)));
end
