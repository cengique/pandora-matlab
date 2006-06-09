function a_doc_multi = reportNeuron(a_bundle, an_index, props)

% reportNeuron - Generates a report of neuron at given an_index of a_bundle.
%
% Usage:
% a_doc_multi = reportNeuron(a_bundle, an_index, props)
%
% Description:
%   Generates a report document with some of the following annotated plots of
% the selected neuron:
%	- raw traces of the neuron
%	- f-I curves
%	- spont and pulse spike shapes
%
% Parameters:
%	a_bundle: a dataset_db_bundle object which contains the neuron
%	an_index: The index to pass to ctFromRows method of a_bundle.
%	props: A structure with any optional properties.
%	  reportLayout: Allows choosing one of predefined report types:
%		1: Only +/- 100 pA traces in one plot (default).
%		2: Only +/- 100 pA traces and spike shapes in one horiz. plot.
%		3: +100 pA raw trace and rate profile stacked vertically.
%		4: Horiz stack of +/- 100 pA raw trace with rate profiles underneath.
%		x: 5-piece trace, spike shape, f-I curve, f-t curve horizontal plot. (N/A)
%	  numTraces: Limit number of traces to show in plot (>=1).
%	  traceAxisLimits: If given, use these limits for traces.
%
% Returns:
%	a_doc_multi: A doc_multi object that can be printed as a PS or PDF file.
%
% Example:
% >> printTeXFile(reportNeuron(mbundle, 2222), 'a.tex')
%
% See also: doc_multi, doc_generate, doc_generate/printTeXFile
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/01/24

% TODO: add a prop (clearPageAtEnd: If given, a page break is inserted at end of document.)

if ~ exist('props')
  props = struct;
end

if ~ isfield(props, 'reportLayout')
  props.reportLayout = 1;		%# default report type
end

if ~ isfield(props, 'horizRow')
  props.horizRow = 1; %# Default due to laziness
end

%# Get raw data traces from bundles
trace_d100 = ctFromRows(a_bundle, an_index, 100);
trace_h100 = ctFromRows(a_bundle, an_index, -100);
trace_id = getNeuronLabel(a_bundle, an_index);
db_id = properTeXLabel(get(get(a_bundle, 'joined_db'), 'id'));

short_caption = ['Raw traces of ' trace_id '.' ];

%# If specified, only include desired number of the available phys. traces
%# Mostly to allow showing only one trace, to avoid cluttered displays.
if isfield(props, 'numTraces')
  trace_d100 = trace_d100(1:max(1, min(length(trace_d100), props.numTraces)));
  trace_h100 = trace_h100(1:max(1, min(length(trace_h100), props.numTraces)));
  caption = [ short_caption ...
	     ' Only ' props.numTraces ' out of available ' length(trace_d100) ...
	     ' for +100pA and ' length(trace_h100) ...
	     ' for -100pA raw traces are shown.' ];
else
  caption = [ short_caption ...
	     ' All available raw traces from the neuron are shown.' ];
end

if isfield(props, 'traceAxisLimits')
  trace_axis_limits = props.traceAxisLimits;
else
  trace_axis_limits = [0 3 -150 50];
end

a_d100_plot = ...
    superposePlots(plotData(trace_d100, '', ...
			    struct('axisLimits', trace_axis_limits, 'timeScale', 's')), ...
		   {}, '+100 pA CIP');
a_h100_plot = ...
    superposePlots(plotData(trace_h100, '', ...
			    struct('axisLimits', trace_axis_limits, 'timeScale', 's')), ...
		   {}, '-100 pA CIP');

orientation = 'x';
%# remove legends
a_d100_plot.legend = {};
a_h100_plot.legend = {};

%# Make a full figure with raw data traces
%#if isfield(props, 'horizRow')
%#  orientation = 'x';
%#else
%#  orientation = 'y';
%#end

plot_title = short_caption;

trace_plot = ...
    plot_stack([a_d100_plot, a_h100_plot], ...
	       trace_axis_limits, orientation, plot_title, ...
	       struct('xLabelsPos', 'bottom', 'yLabelsPos', 'left', ...
		      'yTicksPos', 'left', 'PaperPosition', [0 0 4 3]));

trace_doc = ...
    horizRowTraces(trace_plot, [0 0 4 3], plot_title, caption, short_caption);

%# freq

%# spike shape comparisons 
plot_title = '';
spont_sshape_plot = plotResults(get2ndSpike(trace_d100(1), @periodIniSpont), '2nd spont. spike');
pulse_sshape_plot = plotResults(get2ndSpike(trace_d100(1), @periodPulse), '2nd pulse spike');
both_sshape_plots = ...
    plot_stack([spont_sshape_plot, pulse_sshape_plot], ...
	       [0 20 -100 50], 'x', plot_title, ...
	       struct('yLabelsPos', 'left', 'yTicksPos', 'left'));

trace_sshapes_doc = ...
    horizRowTraces({trace_plot both_sshape_plots}, [0 0 6 3], plot_title, ...
		   caption, short_caption);

trace_sshape_doc = ...
    horizRowTraces({trace_plot setProp(pulse_sshape_plot, 'axisLimits', [0 20 -100 50], ...
				       'noYLabel', 1)}, ...
		   [0 0 6 3], plot_title, caption, short_caption);

short_caption = [ 'Spike shapes of ' trace_id '.' ];
caption = [ short_caption ];

sshape_doc = ...
    doc_plot(both_sshape_plots, ...
	     caption, ['spike shapes of ' trace_id  ...
		       ' from ' db_id ], ...
	     struct('floatType', 'figure', 'center', 1, ...
		    'width', '.9\textwidth', 'shortCaption', short_caption), ...
	     'spike shape comparison', struct);

switch (props.reportLayout)
    case 1
      a_doc_multi = trace_doc;
    case 2
      a_doc_multi = trace_sshape_doc;
    case 3
      a_doc_multi = traceRateDoc(trace_d100, a_d100_plot, trace_id);
    case 4
      a_doc_multi = traceRateDoc(trace_d100, a_d100_plot, trace_id);
      a_doc_multi = ...
	  set(a_doc_multi, 'plot', ...
	      plot_stack({a_doc_multi.plot, ...
			  get(traceRateDoc(trace_h100, a_h100_plot, trace_id), 'plot')}, ...
			 [], 'x', '', ...
			 mergeStructs(props, struct('yLabelsPos', 'left', 'yTicksPos', 'left'))));

%# rest not implemented yet.
end

end

function a_plot_doc = horizRowTraces(plots, paper_position, plot_title, caption, short_caption)
a_plot_doc = ...
    doc_plot(plot_stack(plots, [], 'x', '', struct('PaperPosition', paper_position)), ... 
	     caption, short_caption, ...
	     struct('floatType', 'figure', 'center', 1, ...
		    'height', '.8\textheight', 'shortCaption', short_caption), ...
	     'raw trace figure');
end

function sshape = get2ndSpike(ct, period_func)
  spks = spikes(ct);
  num_spikes = ...
      length(get(withinPeriod(spks, feval(period_func, ct)), 'times'));
  if  num_spikes > 0
    sshape = setProp(getSpike(ct, spks, min(num_spikes, 2)), 'quiet', 1);
  else
    sshape = spike_shape;
  end
end

function a_doc = traceRateDoc(trace_d100, a_d100_plot, trace_id)
  if ~exist('a_d100_plot')
    a_d100_plot = superposePlots(plotData(trace_d100), {}, '+100 pA CIP');
  end

  a_spikes_d100 = spikes(trace_d100);
  

  a_trace_freq_plot = ...
      plot_stack({a_d100_plot, plotFreqVsTime(a_spikes_d100, '', ...
					      struct('axisLimits', [0 3 0 100], ...
						     'timeScale', 's'))}, ...
		 [0 3 NaN NaN], 'y', '+100 pA', ...
		 struct('titlesPos', 'none', 'xLabelsPos', 'bottom', 'xTicksPos', 'bottom'));

  short_caption = ['Raw traces and corresponding rate profile of ' trace_id ...
		   ' for +100 pA injected current.' ];
  caption = short_caption;

  a_doc = doc_plot(a_trace_freq_plot, caption, short_caption, ...
		   struct('floatType', 'figure', 'center', 1, ...
			  'width', '.8\textwidth', 'shortCaption', short_caption), ...
		   'raw trace and rate profile figure');
end
