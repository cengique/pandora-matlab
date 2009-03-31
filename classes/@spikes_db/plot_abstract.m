function a_pm = plot_abstract(a_db, title_str, props)

% plot_abstract - Visualizes the spikes_db by marking spike shapes measurements on the trace plot.
%
% Usage:
% a_pm = plot_abstract(a_db, title_str, props)
%
% Description:
%
%   Parameters:
%	a_db: A spikes_db object.
%	title_str: (Optional) A string to be concatanated to the title.
%	props: A structure with any optional properties passed to trace/plotData.
%		
%   Returns:
%	a_pm: A trace plot.
%
% Example: (see tests_db/plot_abstract)
%
% See also: plot_abstract/plot_abstract, tests_db/plot_abstract, plotFigure
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/08/17

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('title_str', 'var')
  title_str = '';
end

if ~ exist('props', 'var')
  props = struct;
end

% first plot the trace
trace_plot = plotData(a_db.trace, title_str, props);

num_spikes = dbsize(a_db, 1);

% Then superpose all spike measures
[plots(1:num_spikes)] = deal(plot_abstract);
for spike_num=1:num_spikes
  ssp = spike_shape_profile(rows2Struct(a_db, spike_num), spike_shape);
  results = getResults(ssp);
  plots(spike_num) = plot_abstract(ssp, struct('absolute_peak_time', results.Time, ...
					       'no_plot_spike', 1));
end
a_pm = superposePlots([trace_plot, plots]);

