function a_plot = plotData(t, title_str, props)

% plotData - Plots a trace.
%
% Usage: 
% a_plot = plotData(t, title_str, props)
%
% Description:
%   If t is a vector of traces, returns a vector of plot objects.
%
%   Parameters:
%	t: A trace object.
%	title_str: (Optional) String to append to plot title.
%	props: A structure with any optional properties.
%	  timeScale: 's' for seconds, or 'ms' for milliseconds.
%	  quiet: If 1, only display given title_str.
%	  (rest passed to plot_abstract.)
%
%   Returns:
%	a_plot: A plot_abstract object that can be visualized.
%
% See also: trace, trace/plot, plot_abstract
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/11/17

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props')
  props = struct;
end

if ~ exist('title_str')
  title_str = '';
end

%# If input is an array, then return array of plots
num_dbs = length(t);
if num_dbs > 1 
  %# Create array of plots
  [a_plot(1:num_dbs)] = deal(plot_abstract);
  for plot_num = 1:num_dbs
    a_plot(plot_num) = plotData(t(plot_num), title_str, props);
  end
  return;
end

if ~isfield(props, 'timeScale')
  props.timeScale = 'ms';
end

switch props.timeScale
  case 's'
    time = (1:length(t.data)) * t.dt; %# in s
    xlabel = 'time [s]';
  case 'ms'
    time = (1:length(t.data)) * t.dt * 1e3; %# in ms
    xlabel = 'time [ms]';
end

if isfield(t.props, 'y_label')
  ylabel = t.props.y_label;
else
  ylabel = 'voltage [mV]';
end

%# Remove all '_' characters, because they interfere with TeX interpretation

the_legend = t.id;
if isfield(t.props, 'quiet') || isfield(props, 'quiet')
  if isempty(title_str)
    the_title = t.id;
  else
    the_title = title_str;
    the_legend = title_str;
  end
else
  class_name = strrep(class(t), '_', ' ');
  the_title = [ sprintf('%s: %s', class_name, t.id) title_str ];
end

a_plot = plot_abstract({time, t.dy * t.data * 1e3}, ...
		       {xlabel, ylabel}, ...
		       the_title, ...
		       {the_legend}, 'plot', props);
