function h = plot(t, title_str)

% plot - Plots a trace.
%
% Usage: 
% h = plot(t)
%
% Description:
%   Parameters:
%	t: A trace object.
%	title_str: (Optional) String to append to plot title.
%
%   Returns:
%	h: Handle to figure object.
%
% See also: trace, plot_abstract
%
% %Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/04

if ~ exist('title_str')
  title_str = '';
end

if length(t) > 1
  for i=1:length(t)
    plot(t(i), title_str);
  end
else
  h = plotFigure(plotData(t, title_str));
end