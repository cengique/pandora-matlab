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
% $Id: plotPeaksCompare.m 89 2010-04-09 19:54:00Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/11

if ~ exist('props', 'var')
  props = struct;
end

if ~ exist('title_str', 'var')
  title_str = '';
end

% modify time steps since all peaks are calculated using calcCurPeaks here
skip_step = getFieldDefault(props, 'skipStep', 0);

props = ...
    mergeStructs(props, ...
                 struct('skipStep', 1));

% plot comparison of data and model peaks 
a_p = ...
    plot_superpose({...
      plotPeaksCompare(a_md.model_data_vcs, title_str, props), ...
      plotPeaksCompare(a_md.md_pre, title_str, props)}, ...
                   {}, '', ...
                   struct('noCombine', 1, 'noTitle', 1, 'grid', 1, ...
                          'axisProps', struct('Box', 'off'), ...
                          'fixedSize', [2.5 2]));
