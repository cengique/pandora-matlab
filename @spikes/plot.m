function h = plot(s)

% plot - Plots the spikes.
%
% Usage: 
% plot(s)
%
% Description:
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/04

if length(s) > 1
  %# TODO: put all on same figure subplots?
  for i=1:length(s)
    plot(s(i));
  end
else
  h = figure;
  plot_title = sprintf('%s: %s', class(s), s.id);
  set(h, 'Name', plot_title);
  stem(s.times * s.dt * 1e3, ones(length(s.times))); %# in ms
  set(gca, 'YTick', []); %# Remove Y-axis ticks/labels
  axis_size = axis;
  axis_size(4) = 1.1;
  axis(axis_size);
  title(plot_title, 'Interpreter', 'none');
  xlabel('time [ms]');
end