function a_plot = plotData(s)

% plotData - Plots a spikes object.
%
% Usage: 
% a_plot = plotData(s)
%
% Description:
%   Parameters:
%	s: A spikes object.
%
%   Returns:
%	a_plot: A plot_abstract object that can be visualized.
%
% See also: trace, plot_abstract
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/11/17

%# If input is an array, then return array of plots
num_dbs = length(s);
if num_dbs > 1 
  %# Create array of plots
  [a_plot(1:num_dbs)] = deal(plot_abstract);
  for plot_num = 1:num_dbs
    a_plot(plot_num) = plotData(s(plot_num));
  end
  return;
end

%# Remove all '_' characters, because they interfere with TeX interpretation
class_name = strrep(class(s), '_', ' ');
a_plot = plot_abstract({s.times * s.dt * 1e3, ones(length(s.times))}, ...
		       {'time [ms]'}, ...
		       sprintf('%s: %s', class_name, s.id), ...
		       {s.id}, 'stem', struct('YTickLabel', {}));
