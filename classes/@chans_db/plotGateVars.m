function a_subplot = plotGateVars(a_chans_db, chan_name, gate_subnames, props)
  
% plotGateVars - Plot given channel gate variables of the same channel superposed.
%
% Usage: 
% a_plot = plotGateVars(a_chans_db, chan_name, gate_subnames)
%
% Description:
%
%   Parameters:
%	a_chans_db: A chans_db describing channel variables.
%	chan_name: Name of channel that make up the stem of variable
%		names.
% 	gate_subnames: Gate names of the channel.
%	props: A structure with any optional properties.
%	  usePowers: Use the gate powers, Luke.
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

  if ~ exist('props', 'var')
    props = struct;
  end
  
  subplots = {};
  db_id = get(a_chans_db, 'id');

  for gate_subname = gate_subnames
    %# wrapped in two cells by regexp??
    gate_subname = gate_subname{1};

    if ~ isempty(gate_subname)

      if isfield(props, 'usePowers')
        power_name = [ gate_subname '_powered' ];

        % take power of channel gate
        a_chans_db = ...
            addColumns(a_chans_db, { power_name }, ...
                       get(onlyRowsTests(a_chans_db, ':', gate_subname), ...
                           'data') .^ ...
                       a_chans_db.channel_info.(strrep(gate_subname, ...
                                                       '_minf', 'power')) );
        
        gate_subname = power_name;
      end

      gate_subname_label = strrep(gate_subname, '_', ' ');
      subplots = { subplots{:}, ...
		  plotScatter(a_chans_db, [ chan_name '_x' ], gate_subname, [ strrep(chan_name, '_', ' ') ], ...
			      [ db_id ', ' gate_subname_label], ...
			      mergeStructs(props, struct('LineStyle', '-', 'quiet', 1)))};
    end

  end

  a_subplot = plot_superpose(subplots, {}, '');
end
