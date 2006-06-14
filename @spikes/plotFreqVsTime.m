function a_plot = plotFreqVsTime(s, title_str, props)

% plotFreqVsTime - Plots a frequency-time graph from the spikes object.
%
% Usage: 
% a_plot = plotFreqVsTime(s, title_str, props)
%
% Description:
%   If s is a vector of spikes objects, returns a vector of plot objects.
%
%   Parameters:
%	s: A spikes object.
%	title_str: (Optional) String to append to plot title.
%	props: A structure with any optional properties.
%		(passed to plot_abstract)
%
%   Returns:
%	a_plot: A plot_abstract object that can be visualized.
%	title_str: (Optional) String to append to plot title.
%
% See also: trace, plot_abstract
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/05/05

if ~ exist('props')
  props = struct;
end

if ~ exist('title_str')
  title_str = '';
end

%# If input is an array, then return array of plots
num_dbs = length(s);
if num_dbs > 1 
  %# Create array of plots
  [a_plot(1:num_dbs)] = deal(plot_abstract);
  for plot_num = 1:num_dbs
    a_plot(plot_num) = plotFreqVsTime(s(plot_num), title_str);
  end
  return;
end

if ~isfield(props, 'timeScale')
  props.timeScale = 'ms';
end

switch props.timeScale
  case 's'
    time_factor = s.dt;
    x_label = 'time [s]';
  case 'ms'
    time_factor = s.dt * 1e3;
    x_label = 'time [ms]';
end



%# Remove all '_' characters, because they interfere with TeX interpretation
class_name = strrep(class(s), '_', ' ');
freqs = 1 ./ getISIs(s) ./ s.dt;
if length(s.times) > 1
  times = [ (s.times(1) - .1 * time_factor) s.times(1:end-1) ...
	   (s.times(end - 1) + .1 * time_factor) ] * time_factor;
else
  times = [ 0 0 ];
end

a_plot = plot_abstract({times, [ 0 freqs 0 ]}, ...
		       {x_label, 'firing rate [Hz]'}, ...
		       [ sprintf('%s freq-vs-time: %s', class_name, s.id) title_str], ...
		       {s.id}, 'plot', props);
