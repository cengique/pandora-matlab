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
%		2: Only +/- 100 pA traces and spike shapes in one horiz. plot (default).
%		3: 5-piece trace, spike shape, f-I curve, f-t curve horizontal plot. (N/A)
%	  numTraces: Limit number of traces to show in plot (>=1).
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

a_d100_plot = superposePlots(plotData(trace_d100), {}, '+100 pA CIP');
a_h100_plot = superposePlots(plotData(trace_h100), {}, '-100 pA CIP');

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
	       [0 3000 -150 50], orientation, plot_title, ...
	       struct('xLabelsPos', 'bottom', 'yLabelsPos', 'left', ...
		      'yTicksPos', 'left', 'PaperPosition', [0 0 4 3]));

trace_doc = ...
    horizRowTraces(trace_plot, [0 0 4 3], plot_title, caption, short_caption);

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
