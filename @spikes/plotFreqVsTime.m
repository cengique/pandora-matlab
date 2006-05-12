function a_plot = plotFreqVsTime(s, title_str)

% plotFreqVsTime - Plots a frequency-time graph from the spikes object.
%
% Usage: 
% a_plot = plotFreqVsTime(s, title_str)
%
% Description:
%   If s is a vector of spikes objects, returns a vector of plot objects.
%
%   Parameters:
%	s: A spikes object.
%
%   Returns:
%	a_plot: A plot_abstract object that can be visualized.
%	title_str: (Optional) String to append to plot title.
%
% See also: trace, plot_abstract
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/05/05

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

ms_factor = s.dt * 1e3;

%# Remove all '_' characters, because they interfere with TeX interpretation
class_name = strrep(class(s), '_', ' ');
freqs = 1 ./ getISIs(s) ./ s.dt;
a_plot = plot_abstract({s.times(1:end-1) * ms_factor, freqs}, ...
		       {'time [ms]', 'firing rate [Hz]'}, ...
		       [ sprintf('%s freq-vs-time: %s', class_name, s.id) title_str], ...
		       {s.id}, 'plot', struct);
