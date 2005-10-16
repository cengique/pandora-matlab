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

s = size(t);
if max(s) > 1
  %# Column vector
  if s(1) > s(2)
    %# Make a vertical stack plot (default)
    orientation = 'y';
  else
    orientation = 'x';		%# or horizontal
  end
  plotFigure(plot_stack(num2cell(plotData(t)), [], orientation, title_str));
  %#for i=1:length(t)
  %#  plot(t(i), title_str);
  %#end
else
  h = plotFigure(plotData(t, title_str));
end