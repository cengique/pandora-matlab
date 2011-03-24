function a_p = plotPeaksCompare(a_md, title_str, props)

% plotPeaksCompare - Plot I/V curves comparing model and data.
%
% Usage:
% a_p = plotPeaksCompare(a_md, title_str, props)
%
% Parameters:
%   a_md: A model_data_vcs object.
%   title_str: (Optional) Text to appear in the plot title.
%   props: A structure with any optional properties.
%     quiet: If 1, only use given title_str.
%     skipStep: Number of voltage steps to skip at the start (default=0).
%		
% Returns:
%   a_p: A plot_abstract object.
%
% Description:
%
% Example:
% >> a_md = model_data_vcs(model, data_vc)
% >> plotFigure(plotPeaksCompare(a_md, 'I/V curves'))
%
% See also: model_data_vcs, voltage_clamp, plot_abstract, plotFigure
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/11

if ~ exist('props', 'var')
  props = struct;
end

if ~ exist('title_str', 'var')
  title_str = '';
end

if isfield(props, 'quiet')
  all_title = title_str;
else
  all_title = [' IV act, steady, inact; data vs model' title_str ];
end

% modify time steps since all peaks are calculated using calcCurPeaks here
skip_step = getFieldDefault(props, 'skipStep', 0);

% plot comparison of data and model peaks 
a_p = ...
    plot_superpose({...
      plotSteadyIV(calcCurPeaks(a_md.data_vc, 2 + skip_step, ...
                                struct('pulseStartRel', [1 + skip_step .5], 'pulseEndRel', [1 + skip_step 10])), 2 + skip_step, ...
                   all_title, ...
                   struct('noTitle', 1, ...
                          'grid', 1, 'plotPeaks', 1, ... % 'label', 'act'
                          'plotProps', ...
                          struct('Marker', '+', 'LineStyle', 'none', 'Color', 'b'))), ...
      plotSteadyIV(calcCurPeaks(a_md.model_vc, 2 + skip_step, ...
                                struct('pulseStartRel', [1 + skip_step .5], 'pulseEndRel', [1 + skip_step 10])), ...
                   2 + skip_step, '', ...
                   struct('noTitle', 1, ...
                          'label', 'act peak', 'plotPeaks', 1, ...
                          'plotProps', ...
                          struct('Color', 'b'))), ... 
      plotSteadyIV(calcCurPeaks(a_md.data_vc, 2 + skip_step, ...
                                struct('pulseStartRel', [2 + skip_step -30])), 2 + skip_step, '', ...
                   struct('noTitle', 1, ...
                          'grid', 1, 'label', '', 'plotPeaks', 1, ...
                          'plotProps', ...
                          struct('Marker', 'o', 'LineStyle', 'none', 'Color', 'r'))), ...
      plotSteadyIV(calcCurPeaks(a_md.model_vc, 2 + skip_step, struct('pulseStartRel', [2 + skip_step -30])), ...
                   2 + skip_step, '', ...
                   struct('noTitle', 1, ...
                          'label', 'steady', 'plotPeaks', 1, ...
                          'plotProps', ...
                          struct('Color', 'r'))), ...
      plotSteadyIV(calcCurPeaks(a_md.data_vc, 3 + skip_step, ...
                                struct('pulseStartRel', [2 + skip_step .5], 'pulseEndRel', [2 + skip_step 10])), ...
                   2 + skip_step, '', ...
                   struct('noTitle', 1, ...
                          'grid', 1, 'label', '', ...
                          'plotPeaks', 1, ...
                          'plotProps', ...
                          struct('Marker', 'x', 'LineStyle', 'none', 'Color', 'g'))), ...
      plotSteadyIV(calcCurPeaks(a_md.model_vc, 3 + skip_step, ...
                                struct('pulseStartRel', [2 + skip_step .1], 'pulseEndRel', [2 + skip_step 10])), ...
                   2 + skip_step, '', ...
                   struct('noTitle', 1, ...
                          'label', 'inact peak', ...
                          'plotPeaks', 1, ...
                          'plotProps', ...
                          struct('Color', 'g')))}, ...
                   {}, '', ...
                   mergeStructs(props, struct('noCombine', 1, ...
                                              'fixedSize', [2.5 2])));
