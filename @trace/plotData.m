function a_plot = plotData(t)

% plotData - Plots a trace.
%
% Usage: 
% a_plot = plotData(t)
%
% Description:
%   Parameters:
%	t: A trace object.
%
%   Returns:
%	a_plot: A plot_abstract object that can be visualized.
%
% See also: trace, plot_abstract
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/11/17

time = (1:length(t.data)) * t.dt * 1e3; %# in ms

if isfield(t.props, 'y_label')
  ylabel = t.props.y_label;
else
  ylabel = 'voltage [mV]';
end

%# If input is an array, then return array of plots
num_dbs = length(t);
if num_dbs > 1 
  %# Create array of plots
  [a_plot(1:num_dbs)] = deal(plot_abstract);
  for plot_num = 1:num_dbs
    a_plot(plot_num) = plotData(t(plot_num));
  end
  return;
end

%# Remove all '_' characters, because they interfere with TeX interpretation
class_name = strrep(class(t), '_', ' ');
a_plot = plot_abstract({time, t.dy * t.data * 1e3}, ...
		       {'time [ms]', ylabel}, ...
		       sprintf('%s: %s', class_name, t.id), ...
		       {t.id});
