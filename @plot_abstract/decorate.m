function handles = decorate(a_plot)

% decorate - Draws this plot in the current axis.
%
% Usage:
% handles = decorate(a_plot)
%
% Description:
%
%   Parameters:
%	a_plot: A plot_abstract object, or a subclass object.
%		
%   Returns:
%	handles: Handles of graphical objects drawn.
%
% See also: plot_abstract, plot_abstract/plot
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/22

%# Do the decorations based on properties
th = [];
xh = [];
yh = [];

if ~ (isfield(a_plot.props, 'noTitle') && a_plot.props.noTitle == 1)
  th = title(a_plot.title);
end

if ~ (isfield(a_plot.props, 'noXLabel') && a_plot.props.noXLabel == 1)
  if isfield(a_plot.props, 'rotateXLabel')
    xh = xlabel(a_plot.axis_labels{1}, ...
		'Rotation', a_plot.props.rotateXLabel, ...
		'HorizontalAlignment', 'right', ...
		'VerticalAlignment', 'middle'); %#'HorizontalAlignment', 'right'
  else
    xh = xlabel(a_plot.axis_labels{1});
  end
else
  xlabel(''); %# Clear the label
end

if ~ (isfield(a_plot.props, 'noYLabel') && a_plot.props.noYLabel == 1)
  if isfield(a_plot.props, 'rotateYLabel')
    yh = ylabel(a_plot.axis_labels{2}, ...
		'Rotation', a_plot.props.rotateYLabel, ...
		'HorizontalAlignment', 'right');
  else
    yh = ylabel(a_plot.axis_labels{2});
  end
else
  ylabel(''); %# Clear the y-label
end

%# Z-axis?

if isfield(a_plot.props, 'XTickLabel')
  set(gca, 'XTickLabel', a_plot.props.XTickLabel);
end

if isfield(a_plot.props, 'XTick')
  set(gca, 'XTick', a_plot.props.XTick);
end

if isfield(a_plot.props, 'YTickLabel')
  set(gca, 'YTickLabel', a_plot.props.YTickLabel);
end

if isfield(a_plot.props, 'grid')
  grid;
end

%# Only put legend when there is more than one trace
if (length(a_plot.legend) > 1)
  lh = legend(a_plot.legend);
else
  lh = [];
end

handles = struct('title', th, 'axis_labels', [xh, yh], 'legend', lh);
