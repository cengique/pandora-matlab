function h = plot(t)

% plot - Plots a cip_trace_profile object.
%
% Usage: 
% h = plot(t)
%
% Parameters:
%	t: A cip_trace_profile object.
%
% Returns:
%	h: Plot handle(s).
%
% Description:
% Plots contents of this object.
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/15

%# Allow vectors of objects to be plotted at the same time
if length(t) > 1
  for i=1:length(t)
    plot(t(i));
  end
else
  ht = plot(t.trace);
  hsp = plot(t.spikes);
  %# TODO: Hack, fix it
  [hss1 hss2] = plotSpikeShape(t.spont_spike_shape, 'Spont');
  [hss1 hss2] = plotSpikeShape(t.pulse_spike_shape, 'Pulse');

  super_plot = set(superposePlots([plotResults(t.spont_spike_shape) ...
				   plotResults(t.pulse_spike_shape)]), 'legend', {});
  plotFigure(super_plot);
  h = [ht, hsp, hss1, hss2];
end

function [hss1, hss2] = plotSpikeShape(spsh, name)
  if ~ isempty(spsh.trace.data) 
    pr = plotResults(spsh);
    pr = set(pr, 'title', [ name ' ' get(pr, 'title')] )
    hss1 = plotFigure(pr);
    hss2 = plotFigure(plotTPP(spsh));
  else
    hss1 = NaN;
    hss2 = NaN;
  end
