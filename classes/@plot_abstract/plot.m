function handles = plot(a_plot, layout_axis)

% plot - Draws this plot in the current axis.
%
% Usage:
% handles = plot(a_plot, layout_axis)
%
% Description:
%
%   Parameters:
%	a_plot: A plot_abstract object, or a subclass object.
%	layout_axis: The axis position to layout this plot (Optional). 
%		     If NaN, doesn't open a new axis.
%		
%   Returns:
%	handles: Handles of graphical objects drawn.
%
% See also: plot_abstract
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/22

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Get generic verbose switch setting
vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

% Verbose greeting
if verbose
  disp([ 'plot_abstract, plot(' display(a_plot) ') {' ]);
end

if ~ exist('layout_axis', 'var')
  layout_axis = [];
end

% Open the axis
[axis_handle, layout_axis] = openAxis(a_plot, layout_axis);

a_plot_props = get(a_plot, 'props');

% Apply the linestyle here instead of decorate
if isfield(a_plot_props, 'LineStyleOrder')
  set(gca, 'LineStyleOrder', a_plot_props.LineStyleOrder);
  if ~isnan(layout_axis)
    % Otherwise messes with superposed plots, by removing the "hold" state
    set(gca, 'NextPlot', 'replacechildren');
  end
end

if isfield(a_plot_props, 'ColorOrder')
  set(gca, 'ColorOrder', a_plot_props.ColorOrder);
  if ~isnan(layout_axis)
    % Otherwise messes with superposed plots, by removing the "hold" state
    set(gca, 'NextPlot', 'replacechildren');
  end
end

% Run the plot command
if ischar(a_plot.command) && (strcmp(a_plot.command, 'boxplot') || ...
			      strcmp(a_plot.command, 'boxplotp'))
  feval(a_plot.command, a_plot.data{:});
  ph = []; % boxplot returns no handle???
elseif ischar(a_plot.command) && strcmp(a_plot.command, 'silhouette')
  % silhouette plot requires two return values
  [silh, ph] = feval(a_plot.command, a_plot.data{:});
elseif ischar(a_plot.command) && isempty(a_plot.command)
  % do nothing, probably its from plot_stack
  ph = [];
else
  % Should work string or function handle the same way
  if ~ isempty(a_plot.data)
    ph = feval(a_plot.command, a_plot.data{:});
  else
    ph = gca; 
  end
end

% pass all of these to plot props
if isfield(a_plot.props, 'plotProps')
  set(ph, a_plot.props.plotProps);
end

% Add titles, etc. (Not here! see plotFigure)
%handles = decorate(a_plot);

% Add plot handle
handles.plot = ph;
handles.axis = axis_handle;

if verbose
  disp([ 'plot_abstract, plot() }' ]);
end
