function h = plot(t)

% plot - Plots a trace.
%
% Usage: 
% plot(t)
%
% Description:
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/04

if length(t) > 1
  for i=1:length(t)
    plot(t(i));
  end
else
  h = figure;
  class(t)
  plot_title = sprintf('%s: %s', class(t), t.id);
  set(h, 'Name', plot_title);
  time = (1:length(t.data)) * t.dt * 1e3; %# in ms
  plot(time, t.dy * t.data * 1e3); %# mV or mA
  title(plot_title, 'Interpreter', 'none');
  xlabel('time [ms]');
  if isfield(t.props, 'y_label')
    ylabel(t.props.y_label);
  end
end