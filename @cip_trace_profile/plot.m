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
  s = t.spont_spike_shape
  if ~ isempty(s.trace.data) 
    hss1 = plotFigure(plotResults(t.spont_spike_shape));
    hss2 = plotFigure(plotTPP(t.spont_spike_shape));
  else
    hss1 = NaN;
    hss2 = NaN;
  end
  h = [ht, hsp, hss1, hss2];
end