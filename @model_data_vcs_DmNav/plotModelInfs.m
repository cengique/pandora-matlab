function a_p = plotModelInfs(a_md, title_str, props)

% plotModelInfs - Plot model m_inf and h_inf curves.
%
% Usage:
% a_p = plotModelInfs(a_md, title_str, props)
%
% Parameters:
%   a_md: A model_data_vcs_DmNav object.
%   title_str: (Optional) Text to appear in the plot title.
%   props: A structure with any optional properties.
%     quiet: If 1, only use given title_str.
%		
% Returns:
%   a_p: A plot_abstract object.
%
% Description:
%
% Example:
% >> a_md = model_data_vcs_DmNav(model, data_vc)
% >> plotFigure(plotModelInfs(a_md, 'my model'))
%
% See also: model_data_vcs_DmNav, voltage_clamp, plot_abstract, plotFigure
%
% $Id: plotModelInfs.m 89 2010-04-09 19:54:00Z cengiz $
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
  all_title = [ ', ' a_md.id get(a_md.model_f, 'id') ' m_inf, m_inf^3, and h_inf ' title_str ];
end

% find the current (I) object
if isfield(a_md.model_f.f, 'I')
  I = a_md.model_f.I;
else
  I = a_md.model_f;
end

a_p = ...
    plot_superpose({plot_abstract(I.m.inf, all_title), ...
                    plot_abstract(I.m.inf .^ 3), ...
                    plot_abstract(I.h.inf, '', ...
                          struct('quiet', 1, 'noTitle', 1, 'fixedSize', [2.5 2], ...
                                 'plotProps', struct('LineWidth', 2)))});
