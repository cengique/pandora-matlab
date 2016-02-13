function a_p = plotDataCompare(a_md, title_str, props)

% plotDataCompare - Superpose model and data raw traces.
%
% Usage:
% a_p = plotDataCompare(a_md, title_str, props)
%
% Parameters:
%   a_md: A model_data_vcs object.
%   title_str: (Optional) Text to appear in the plot title.
%   props: A structure with any optional properties.
%     quiet: If 1, only use given title_str.
%     zoom: Zoom into activation or inactivation parts if 'act' or
%           'inact', resp.
%     skipStep: Number of voltage steps to skip at the start for zoom (default=0).
%     show: 'sub' for subtracted current, and 'v' for voltage trace at
%     	    the bottom row.
%     levels: Only plot these current and voltage levels
%     colorLevels: Cycle colors every this number.
%     axisLimits: Set current traces to these limits unless 'zoom' prop
%     	    is specified.
% 
% Returns:
%   a_p: A plot_abstract object.
%
% Description:
%
% Example:
% >> a_md = model_data_vcs(model, data_vc)
% >> plotFigure(plotDataCompare(a_md, 'my model'))
%
% See also: model_data_vcs, voltage_clamp, plot_abstract, plotFigure
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/12

if ~ exist('props', 'var')
  props = struct;
end

if ~ exist('title_str', 'var')
  title_str = '';
end

%color_num_levels = getFieldDefault(props, 'colorLevels', size(a_md.data_vc.v_steps, 2));

a_p = ...
    plot_superpose({...
      plotDataCompare(a_md.model_data_vcs, title_str, props), ...
      plotDataCompare(a_md.md_pre, title_str, props)}, {}, '', ...
                   mergeStructs(props, struct('noTitle', 1, ... 
                                              'fixedSize', [4 3])));

