function a_p = plot_abstract(a_md, title_str, props)

% plot_abstract - Superpose model and data raw traces.
%
% Usage:
% a_p = plot_abstract(a_md, title_str, props)
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
% >> plotFigure(plot_abstract(a_md, 'my model'))
%
% See also: model_data_vcs, voltage_clamp, plot_abstract, plotFigure
%
% $Id: plot_abstract.m 238 2010-10-22 22:41:07Z cengiz $
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

a_p = ...
    plot_stack({...
      plotDataCompare(a_md, title_str, ...
                      mergeStructs(props, ...
                                   struct('showSub', 1, 'showV', 1))), ...
      plot_stack({plotPeaksCompare(a_md, '', struct('legendLocation', 'EastOutside')), ...
                  plotModelInfs(a_md, '', struct('legendLocation', 'EastOutside')), ...
                  plotModelTaus(a_md, '', struct('legendLocation', 'EastOutside'))}, [], 'y', '', ...
                 struct('titlesPos', 'none', 'xLabelsPos', 'bottom'))}, ...
               [], 'x', all_title, ...
               mergeStructs(props, ...
                            struct('titlesPos', 'none', 'xLabelsPos', 'bottom', ...
                                   'relativeSizes', [2 2], ...
                                   'fixedSize', [8 5], 'noTitle', 1)));
