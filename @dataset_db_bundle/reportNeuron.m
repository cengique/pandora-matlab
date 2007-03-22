function a_doc_multi = reportNeuron(a_bundle, an_index, props)

% reportNeuron - Generates a report of neuron at given an_index of a_bundle.
%
% Usage:
% a_doc_multi = reportNeuron(a_bundle, an_index, props)
%
% Description:
%   Generates a report document with preset layouts of annotated plots of
% the selected neuron. See reportLayout below for presets.
%
% Parameters:
%	a_bundle: a dataset_db_bundle object which contains the neuron
%	an_index: The index to pass to ctFromRows method of a_bundle.
%	props: A structure with any optional properties.
%	  reportLayout: Allows choosing one of predefined report types (strings):
%		1: Only +/- 100 pA traces in one plot (default).
%		1a/b: Either one of the +/- 100 pA traces in one plot.
%		2: Only +/- 100 pA traces and spike shapes in one horiz. plot.
%		3: +100 pA raw trace and rate profile stacked vertically.
%		3b: -100 pA raw trace and rate profile stacked vertically.
%		4: Horiz stack of +/- 100 pA raw trace with rate profiles underneath.
%		5: 5-piece trace, spike shape, f-I curve, f-t curve quad-plot.
%	  numTraces: Limit number of traces to show in plot (>=1).
%	  traces: List of acceptable traces to load.
%	  traceAxisLimits: If given, use these limits for trace plots.
%	  rateAxisLimits: If given, use these limits for rate plots.
%	  fIAxisLimits: If given, use these limits for fIcurve plots.
%	  fIstats: Add a fI-stats plot in addition to the curve.
%	  sshapeAxisLimits: If given, use these limits for spike shape plots.
%	  sshapeResults: If 1, plot measures on the spike shape (default=1).
%
% Returns:
%	a_doc_multi: A doc_multi object that can be printed as a PS or PDF file.
%
% Example:
% >> printTeXFile(reportNeuron(mbundle, 2222), 'a.tex')
% or:
% >> plotFigure(get(reportNeuron(mbundle, 2222), 'plot'))
%
% See also: doc_multi, doc_generate, doc_generate/printTeXFile
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/01/24

%# TODO: add a prop (clearPageAtEnd: If given, a page break is inserted at end of document.)

if ~ exist('props')
  props = struct;
end

if isa(an_index, 'tests_db')
  num_items = dbsize(an_index, 1);
else
  num_items = length(an_index);
end

%# If input is an array, then also return array
if num_items > 1 
  %# Create array of outputs
  for item_num = 1:num_items
    if isa(an_index, 'tests_db')
      a_doc_multi(item_num) = ...
	  reportNeuron(a_bundle, onlyRowsTests(an_index, item_num, ':', ':'), props);
    else
      a_doc_multi(item_num) = ...
	  reportNeuron(a_bundle, an_index(item_num), props);
    end
  end
  return;
end

if ~ isfield(props, 'reportLayout')
  props.reportLayout = 1;		%# default report type
end

%# convert to string from numeric
if isnumeric(props.reportLayout)
  props.reportLayout = num2str(props.reportLayout);
end

if ~ isfield(props, 'horizRow')
  props.horizRow = 1; %# Default due to laziness
end

db_id = properTeXLabel(get(get(a_bundle, 'joined_db'), 'id'));

switch (props.reportLayout)
    %# Only trace plots
    case '1'
      %# Get raw data traces from bundles
      [trace_d100, trace_h100, trace_id, short_caption, caption] = traceData;
      [a_d100_plot, a_h100_plot, trace_plot, trace_axis_limits] = tracePlots;
      
      a_doc_multi = ...
	  horizRowTraces(trace_plot, [0 0 4 3], plot_title, caption, short_caption);

    case '1a'
      %# Get raw data traces from bundles
      [trace_d100, trace_h100, trace_id, short_caption, caption] = traceData;
      [a_d100_plot, a_h100_plot, trace_plot, trace_axis_limits] = tracePlots;

      a_doc_multi = doc_plot(a_d100_plot, caption, short_caption, ...
			     struct('floatType', 'figure', 'center', 1, ...
				    'width', '.8\textwidth', 'shortCaption', short_caption), ...
			     'raw +100pA trace figure');
      
    case '1b'
      %# Get raw data traces from bundles
      [trace_d100, trace_h100, trace_id, short_caption, caption] = traceData;
      [a_d100_plot, a_h100_plot, trace_plot, trace_axis_limits] = tracePlots;
      
      a_doc_multi = doc_plot(a_h100_plot, caption, short_caption, ...
			     struct('floatType', 'figure', 'center', 1, ...
				    'width', '.8\textwidth', 'shortCaption', short_caption), ...
			     'raw +100pA trace figure');

    case '2'
      [trace_d100, trace_h100, trace_id, short_caption, caption] = traceData;
      [a_d100_plot, a_h100_plot, trace_plot, trace_axis_limits] = tracePlots;
      %# spike shape comparisons 
      plot_title = '';
      [spont_sshape_plot, pulse_sshape_plot, both_sshape_plots] = ...
	  spikeShapePlots(plot_title, trace_d100, props);

      a_doc_multi = ...
	  doc_plot(plot_stack({set(trace_plot, 'title', ''), ...
			       setProp(pulse_sshape_plot, 'noYLabel', 1)}, [], 'x', ...
			      short_caption, ...
			      struct('PaperPosition', [0 0 6 3], ...
				     'relativeSizes', [2 1])), ... 
		   caption, properTeXFilename([ trace_id '_raw_traces_sshapes']), ...
		   struct('floatType', 'figure', 'center', 1, ...
			  'height', '.8\textheight', 'shortCaption', short_caption), ...
		   'raw trace sshape figure');

    case '3'
      [trace_d100, trace_h100, trace_id, short_caption, caption] = traceData;
      [a_d100_plot, a_h100_plot, trace_plot, trace_axis_limits] = tracePlots;
      a_trace_rate_plot = traceRatePlot(trace_d100, a_d100_plot, trace_id, props);
      short_caption = ['Raw traces and corresponding rate profile of ' trace_id ...
		       ' for +100 pA injected current.' ];
      caption = short_caption;
      a_doc_multi = doc_plot(a_trace_rate_plot, caption, short_caption, ...
			     struct('floatType', 'figure', 'center', 1, ...
				    'width', '.8\textwidth', 'shortCaption', short_caption), ...
			     'raw trace and rate profile figure');

    case '3b'
      [trace_d100, trace_h100, trace_id, short_caption, caption] = traceData;
      [a_d100_plot, a_h100_plot, trace_plot, trace_axis_limits] = tracePlots;
      a_trace_rate_plot = traceRatePlot(trace_h100, a_h100_plot, trace_id, props);
      short_caption = ['Raw traces and corresponding rate profile of ' trace_id ...
		       ' for -100 pA injected current.' ];
      caption = short_caption;
      a_doc_multi = doc_plot(a_trace_rate_plot, caption, short_caption, ...
			     struct('floatType', 'figure', 'center', 1, ...
				    'width', '.8\textwidth', 'shortCaption', short_caption), ...
			     'raw trace and rate profile figure');
      
    case '4'
      [trace_d100, trace_h100, trace_id, short_caption, caption] = traceData;
      [a_d100_plot, a_h100_plot, trace_plot, trace_axis_limits] = tracePlots;
      short_caption = ['Raw traces and corresponding rate profiles of ' trace_id ...
		       ' for +/- 100 pA injected currents.' ];
      caption = short_caption;
      a_doc_multi = ...
	  doc_plot(plot_stack({traceRatePlot(trace_d100, a_d100_plot, trace_id, props), ...
			       traceRatePlot(trace_h100, a_h100_plot, trace_id, props)}, ...
			      [], 'x', '', ...
			      mergeStructs(props, struct('yLabelsPos', 'left', ...
							 'yTicksPos', 'left'))), ...
		   caption, short_caption, ...
		   struct('floatType', 'figure', 'center', 1, ...
			  'width', '.8\textwidth', 'shortCaption', short_caption), ...
		   'raw trace and rate profile figure');

    case '5'
      [trace_d100, trace_h100, trace_id, short_caption, caption] = traceData;
      [a_d100_plot, a_h100_plot, trace_plot, trace_axis_limits] = tracePlots;
      trace_plot_quad = ...
	  plot_stack({traceRatePlot(trace_d100, a_d100_plot, trace_id, props), ...
		      traceRatePlot(trace_h100, a_h100_plot, trace_id, props)}, ...
		     [], 'x', '', ...
		     mergeStructs(props, struct('yLabelsPos', 'left', ...
						'yTicksPos', 'left')));
      [spont_sshape_plot, pulse_sshape_plot, both_sshape_plots] = ...
	  spikeShapePlots(plot_title, trace_d100, props);
      if isfield(props, 'fIAxisLimits')
	fI_axis_limits = props.fIAxisLimits;
      else
	fI_axis_limits = [0 200 0 100];
      end

      fIcurve_plot = plotfICurve(a_bundle, an_index, ...
				 mergeStructs(props, struct('axisLimits', fI_axis_limits)));

      if isfield(props, 'fIstats')
	fIcurve_plot = ...
	    plot_superpose({fIcurve_plot, ...
			    plotfICurveStats(a_bundle, 'avg.', struct('quiet', 1))});
      end

      sshape_ratecurve_plot = ...
	  plot_stack({pulse_sshape_plot, fIcurve_plot}, ...
		     [], 'y', '', mergeStructs(props, struct));

      short_caption = ...
	  ['Raw traces with corresponding rate profiles of ' trace_id ...
	   ' for +/- 100 pA injected currents, close-up view of a spike shape ' ...
	   'from the current-injection period, and the current-rate relationship plots.' ];
      caption = short_caption;
      a_doc_multi = ...
	  doc_plot(plot_stack({trace_plot_quad, sshape_ratecurve_plot}, ...
			      [], 'x', trace_id, ...
			      mergeStructs(props, ...
					   struct('yLabelsPos', 'left', ...
						  'relativeSizes', [2 1]))), ...
		   caption, [ trace_id '_raw_traces_sshape_fIcurve' ], ...
		   struct('floatType', 'figure', 'center', 1, ...
			  'width', '.8\textwidth', 'shortCaption', short_caption), ...
		   'raw trace and rate profile figure');


      %# rest not implemented yet.
      otherwise
	error(['reportLayout "' props.reportLayout '" not defined!']);
  end

  %# The following are nested functions, sharing this functions workspace:

  %# Not used:
function sshape_doc = bothSShapeDoc
  %# freq
  short_caption = [ 'Spike shapes of ' trace_id '.' ];
  caption = [ short_caption ];
  
  sshape_doc = ...
      doc_plot(both_sshape_plots, ...
	       caption, ['spike shapes of ' trace_id  ...
			 ' from ' db_id ], ...
	       struct('floatType', 'figure', 'center', 1, ...
		      'width', '.9\textwidth', 'shortCaption', short_caption), ...
	       'spike shape comparison', struct);
end

function [a_d100_plot, a_h100_plot, trace_plot, trace_axis_limits] = tracePlots()
  if isfield(props, 'traceAxisLimits')
    trace_axis_limits = props.traceAxisLimits;
  else
    trace_axis_limits = [0 3 -150 50];
  end

  if ~ isempty(trace_d100)
    a_d100_plot = ...
	superposePlots(plotData(trace_d100, '', ...
				mergeStructs(props, struct('axisLimits', trace_axis_limits, ...
							   'timeScale', 's'))), ...
		       {}, '+100 pA');
  else
    a_d100_plot = plot_abstract;
  end

  if ~ isempty(trace_h100)
    a_h100_plot = ...
	superposePlots(plotData(trace_h100, '', ...
				mergeStructs(props, struct('axisLimits', trace_axis_limits, ...
							   'timeScale', 's'))), ...
		       {}, '-100 pA');
  else
    a_h100_plot = plot_abstract;
  end
  
  %# remove legends
  a_d100_plot.legend = {};
  a_h100_plot.legend = {};

  plot_title = short_caption;
  trace_plot = ...
      plot_stack([a_d100_plot, a_h100_plot], ...
		 trace_axis_limits, 'x', plot_title, ...
		 struct('xLabelsPos', 'bottom', 'yLabelsPos', 'left', ...
			'yTicksPos', 'left', 'PaperPosition', [0 0 4 3]));
end

function [trace_d100, trace_h100, trace_id, short_caption, caption] = traceData
  trace_d100 = ctFromRows(a_bundle, an_index, 100, props);
  trace_h100 = ctFromRows(a_bundle, an_index, -100, props);
  trace_id = getNeuronLabel(a_bundle, an_index);

  short_caption = ['Raw traces of ' trace_id '.' ];

  %# If specified, only include desired number of the available phys. traces
  %# Mostly to allow showing only one trace, to avoid cluttered displays.
  if isfield(props, 'numTraces')
    if iscell(props.numTraces)
      %# Take traces specified in the numTraces cell array
      trace_d100 = trace_d100(props.numTraces{1});
      trace_h100 = trace_h100(props.numTraces{2});
      caption = [ short_caption ...
		 ' Only ' num2str(props.numTraces{1}) ' of ' num2str(length(trace_d100)) ...
		 ' for +100pA and ' num2str(props.numTraces{1}) ' of ' ...
		 num2str(length(trace_h100)) ' for -100pA raw traces are shown.' ];
    else
      trace_d100 = trace_d100(1:max(1, min(length(trace_d100), props.numTraces)));
      trace_h100 = trace_h100(1:max(1, min(length(trace_h100), props.numTraces)));
      caption = [ short_caption ...
		 ' Only ' props.numTraces ' out of available ' length(trace_d100) ...
		 ' for +100pA and ' length(trace_h100) ...
		 ' for -100pA raw traces are shown.' ];
    end
  else
    caption = [ short_caption ...
	       ' All available raw traces from the neuron are shown.' ];
  end
end

end

%# The following functions are not nested functions:

function [spont_sshape_plot, pulse_sshape_plot, both_sshape_plots] = ...
      spikeShapePlots(plot_title, trace_d100, props)
  if isfield(props, 'sshapeAxisLimits')
    sshape_axis_limits = props.sshapeAxisLimits;
  else
    sshape_axis_limits = [0 20 -100 50];
  end
  
  if isfield(props, 'sshapeResults') && props.sshapeResults == 0
    plot_func = 'plotData'
  else
    plot_func = 'plotResults'
  end
  
  spont_sshape_plot = ...
      feval(plot_func, get2ndSpike(trace_d100(1), @periodIniSpont), '2nd spont. spike', ...
	    mergeStructs(props, struct('axisLimits', sshape_axis_limits)));
  pulse_sshape_plot = ...
      feval(plot_func, get2ndSpike(trace_d100(1), @periodPulse), '2nd pulse spike', ...
	    mergeStructs(props, struct('axisLimits', sshape_axis_limits)));
  both_sshape_plots = ...
      plot_stack([spont_sshape_plot, pulse_sshape_plot], ...
		 sshape_axis_limits, 'x', plot_title, ...
		 struct('yLabelsPos', 'left', 'yTicksPos', 'left'));
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

function a_trace_rate_plot = traceRatePlot(a_trace, a_trace_plot, trace_id, props)
  a_spikes_d100 = spikes(a_trace);

  if isfield(props, 'rateAxisLimits')
    rate_axis_limits = props.rateAxisLimits;
  else
    rate_axis_limits = [0 3 0 100];
  end

  a_trace_rate_plot = ...
      plot_stack({a_trace_plot, ...
		  plotFreqVsTime(a_spikes_d100, '', ...
				 mergeStructs(props, struct('axisLimits', rate_axis_limits, ...
							    'timeScale', 's')))}, ...
		 [0 3 NaN NaN], 'y', get(a_trace_plot, 'title'), ...
		 struct('titlesPos', 'none', 'xLabelsPos', 'bottom', 'xTicksPos', 'bottom', ...
			'relativeSizes', [2 1]));

end
