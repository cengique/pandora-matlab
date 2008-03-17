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
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/22

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('title_str')
  title_str = '';
end

s = size(a_plot);
if max(s) > 1
  % Column vector
  if s(1) > s(2)
    % Make a vertical stack plot (default)
    orientation = 'y';
  else
    orientation = 'x';		% or horizontal
  end
  handle = plotFigure(plot_stack(num2cell(a_plot), [], orientation, title_str));
else
  handle = figure;
  title = [ get(a_plot, 'title') title_str ];
  set(handle, 'Name', title);

  % wait a second for figure to materialize (workaround for
  % Compiz-fusion)
  a_timer = timer('StartDelay', .5, 'TimerFcn', '1');
  start(a_timer); wait(a_timer);
  
  if isfield(a_plot.props, 'PaperPosition')
    set(handle, 'PaperPosition', a_plot.props.PaperPosition);
    old_units = get(handle, 'Units')
    % Paper position is in inches
    set(handle, 'Units', 'inches');
    old_pos = get(handle, 'Position')
    % get the width and height from the paper position
    set(handle, 'Position', ...
                [ old_pos(1:2) a_plot.props.PaperPosition(3:4) ]);
    set(handle, 'Units', old_units);
  end

  %position = [0 0 1 1];
  % Save plot_abstract object in the figure
  set(handle, 'UserData', a_plot);

  if ~isfield(a_plot.props, 'resizeControl') || a_plot.props.resizeControl == 1
    set(handle, 'ResizeFcn', ['clf; a_plot = get(gcf, ''UserData''); plot(a_plot); decorate(a_plot);']);
  else
    % print figure at the size seen on screen
    set(handle, 'PaperPositionMode', 'auto');
  end

  plot(a_plot);
  decorate(a_plot);
  
  % pass all of these to plot props
  if isfield(a_plot.props, 'figureProps')
    set(handle, a_plot.props.figureProps);
  end

end

% OBSOLETE, REDUNDANT! These are already considered in plot.m
function position = allocateBorders(a_plot, title)
  if isempty(title)
    titleheight = 0;
  else
    titleheight = 0.05;
  end


  axis_labels = get(a_plot, 'axis_labels');
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

  % Put default borders: less border for top title, no border on right side
  position = [left_border, bottom_border, ...
	      1 - left_border - border/4, (1 - titleheight - bottom_border)];
  