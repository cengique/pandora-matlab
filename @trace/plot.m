function h = plot(t)

% plot - Plots a trace.
%
% Usage: 
% h = plot(t)
%
% Description:
%   Parameters:
%	t: A trace object.
%
%   Returns:
%	h: Handle to figure object.
%
% See also: trace, plot_abstract
%
% %Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/04

if length(t) > 1
  for i=1:length(t)
    plot(t(i));
  end
else
  h = plotFigure(plotData(t));
end