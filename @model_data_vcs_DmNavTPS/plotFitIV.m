function a_p = plotFitIV(a_md, title_str, props)

% plotFitIV - Convenience plot for DmNavs showing data and IV fits.
%
% Usage:
% a_p = plotFitIV(a_md, title_str, props)
%
% Parameters:
%   a_md: A model_data_vcs object.
%   title_str: (Optional) Text to appear in the plot title.
%   props: A structure with any optional properties.
%     quiet: If 1, only use given title_str.
%     yLims: 2-element vector for limits of current on y-axis.
%     inact: If 1 (default), show inactivation window, too.
%		
% Returns:
%   a_p: A plot_abstract object.
%
% Description:
%
% Example:
% >> a_md = model_data_vcs(model, data_vc)
% >> plotFigure(plotFitIV(a_md, 'my model'))
%
% See also: model_data_vcs, voltage_clamp, plot_abstract, plotFigure
%
% $Id: plotFitIV.m 276 2010-11-09 23:30:35Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/12

if ~ exist('props', 'var')
  props = struct;
end

if ~ exist('title_str', 'var')
  title_str = '';
end

if isfield(props, 'quiet')
  all_title = title_str;
else
  all_title = [ get(a_md, 'id') title_str ];
end

show_inact = getFieldDefault(props, 'inact', 1);

y_lims = getFieldDefault(props, 'yLims', [NaN NaN]);

first_p = ...
    plotDataCompare(a_md, '', ...
                    struct('axisLimits', [23 43 NaN NaN], ...
                           'noLegends', 1));
a_ps = first_p.plots;


second_p = ...
    plotDataCompare(a_md, '', ...
                  struct('axisLimits', [123 131 NaN NaN], ...
                         'noLegends', 1));

if show_inact ~= 0
  first_p.plots{1} = ...
      set(first_p.plots{1}, 'axis_labels', ...
                        {'', [ a_md.name ': ' get(a_md, 'id') ' [nA]' ]});
  stack_args = {first_p, second_p};
  rel_sizes = [2 2 2];
else
  stack_args = {first_p};
  rel_sizes = [2 2];
end

a_p = plot_stack({...
  stack_args{:}, ...
  plotPeaksCompare(a_md, '', ...
                              struct('vLimits', [-80 60], 'noLegends', 1, ...
                                     'tightLimits', 0))}, ...
                      [NaN NaN y_lims], 'x', all_title, ...
  mergeStructs(props, struct('noTitle', 1, 'yLabelsPos', 'left', 'yTicksPos', 'left', 'fixedSize', [5 2], ...
                             'relativeSizes', rel_sizes)));
