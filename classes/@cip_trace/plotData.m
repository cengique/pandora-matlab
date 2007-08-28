function a_plot = plotData(t, title_str, props)

% plotData - Plots a trace by calling trace/plotData but also adds optionaldecorations.
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
%	  stimBar: If true, put a bar indicating the CIP duration.
%	  (rest passed to trace/plotData)
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

%# Create data plot
a_plot = plotData(t.trace, title_str, props);

%# If specified, add stimulation bar
if isfield(props, 'stimBar') && props.stimBar

if ~isfield(props, 'timeScale')
  props.timeScale = 'ms';
end

switch props.timeScale
  case 's'
    time = get(t, 'dt'); %# in s
  case 'ms'
    time = get(t, 'dt') * 1e3; %# in ms
end

pulse_end = t.pulse_time_start + t.pulse_time_width;

%# Find top of spikes in CIP period
[max_val, max_idx] = calcMax(t, periodPulse(t));

% Place a bar between these limits
bar_y = max(40, (max_val + max_val * .2) * get(t, 'dy') * 1e3); %# [mV]
bar_top = bar_y + bar_y * .1;

% superpose on the original data plot
a_plot = ...
    plot_superpose({a_plot, ...
                    plot_abstract({[t.pulse_time_start,  t.pulse_time_start, pulse_end, pulse_end] .* time, ...
                    [bar_y, bar_top, bar_top, bar_y], 'k'}, {}, [], {}, 'patch')});

end

