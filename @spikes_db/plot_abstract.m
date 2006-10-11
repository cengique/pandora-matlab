function a_pm = plot_abstract(a_db, title_str)

% plot_abstract - Visualizes the spikes_db by marking spike shapes measurements on the trace plot.
%
% Usage:
% a_pm = plot_abstract(a_db, title_str)
%
% Description:
%
%   Parameters:
%	a_db: A spikes_db object.
%	title_str: (Optional) A string to be concatanated to the title.
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

if ~ exist('title_str')
  title_str = '';
end

%# first plot the trace
trace_plot = plotData(a_db.trace, title_str);

num_spikes = dbsize(a_db, 1);

%# Then superpose all spike measures
[plots(1:num_spikes)] = deal(plot_abstract);
for spike_num=1:num_spikes
  ssp = spike_shape_profile(rows2Struct(a_db, spike_num), spike_shape);
  results = getResults(ssp);
  plots(spike_num) = plot_abstract(ssp, struct('absolute_peak_time', results.Time, ...
					       'no_plot_spike', 1));
end
a_pm = superposePlots([trace_plot, plots]);

