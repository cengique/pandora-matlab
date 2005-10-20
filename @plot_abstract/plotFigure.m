function handle = plotFigure(a_plot, title_str)

% plotFigure - Draws this plot alone in a new figure window.
%
% Usage:
% handle = plotFigure(a_plot)
%
% Description:
%
%   Parameters:
%	a_plot: A plot_abstract object, or a subclass object.
%	title_str: (Optional) String to append to plot title.
%		
%   Returns:
%	handle: Handle of new figure.
%
% See also: plot_abstract, plot_abstract/plot, plot_abstract/decorate
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/22

if ~ exist('title_str')
  title_str = '';
end

s = size(a_plot);
if max(s) > 1
  %# Column vector
  if s(1) > s(2)
    %# Make a vertical stack plot (default)
    orientation = 'y';
  else
    orientation = 'x';		%# or horizontal
  end
  plotFigure(plot_stack(num2cell(a_plot), [], orientation, title_str));
else
  handle = figure;
  title = [ get(a_plot, 'title') title_str ];
  set(handle, 'Name', title);


  if isempty(title)
    titleheight = 0;
  else
    titleheight = 0.05;
  end

  if isfield(a_plot.props, 'border')
    border = a_plot.props.border;
  else
    border = 0.15;
  end

  axis_labels = get(a_plot, 'axis_labels')
  if length(axis_labels) < 1 || isempty(axis_labels(1))
    left_border = 0;
  else
    left_border = border / 2;
  end

  if length(axis_labels) < 2 || isempty(axis_labels(2))
    bottom_border = 0;
  else
    bottom_border = border / 2;
  end

  %# Put default borders: less border for top title, no border on right side
  position = [left_border, bottom_border, ...
	      1 - left_border - border/4, (1 - titleheight - bottom_border)];

  %# Save plot_abstract object in the figure
  set(handle, 'UserData', a_plot);
  set(handle, 'ResizeFcn', ['clf; plot(get(gcf, ''UserData''), [' num2str(position) '])']);

  %#plot(a_plot, position);
  decorate(a_plot);
end