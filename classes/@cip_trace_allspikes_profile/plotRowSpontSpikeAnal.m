function a_plot = plotRowSpontSpikeAnal(prof, title_str)

% plotRowSpontSpikeAnal - Creates a row of plots that show spontaneous spikes, starting from the whole trace, zooming into the individual spike.
%
% Usage: 
% a_plot = plotRowSpontSpikeAnal(prof, title_str)
%
% Description:
%
%   Parameters:
%	prof: A cip_trace_allspikes_profile object.
%	title_str: (Optional) String to append to plot title.
%
%   Returns:
%	a_plot: A plot_abstract object that can be visualized.
%
% See also: trace, cip_trace, spike_shape/plotCompareMethodsSimple, plot_abstract
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/05/23

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

if ~ exist('title_str')
  title_str = '';
end

%# If input is an array, then return array of plots
num_dbs = length(prof);
if num_dbs > 1 
  %# Create array of plots
  [a_plot(1:num_dbs)] = deal(plot_stack);
  for plot_num = 1:num_dbs
    a_plot(plot_num) = plotRowSpontSpikeAnal(prof(plot_num), title_str);
  end
  return;
end

%# Remove all '_' characters, because they interfere with TeX interpretation
class_name = strrep(class(prof), '_', ' ');

quiet_trace = setProp(prof.trace, 'quiet', 1);

%# Analyze a spontaneous spike
try 
  a_spike = getSpike(quiet_trace, prof.spikes, 2);
  comparison_plots = plotCompareMethodsSimple(a_spike, title_str);
catch
  err = lasterror;
  if strcmp(err.identifier, 'spike_shape:not_a_spike')
    %# Feeble attempt to get next spike 
    %# TODO: not-a-spikes should've been removed by this time!
    a_spike = getSpike(quiet_trace, prof.spikes, 3);
    comparison_plots = plotCompareMethodsSimple(a_spike, title_str);
  else
    rethrow(err);
  end
end
top_row = comparison_plots.plots{2};

a_plot = plot_stack({plotData(quiet_trace), ...
		     plotData(withinPeriod(quiet_trace, period(1, 100*1e-3/prof.trace.dt))), ...
		     plotResults(a_spike), ...
		     top_row.plots{1} }, [NaN NaN -80 50], 'x', ...
		    [ sprintf('%s: %s', class_name, get(prof, 'id')) title_str ], ...
		    struct('yLabelsPos', 'left'));
