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
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/12

if ~ exist('props', 'var')
  props = struct;
end

if ~ exist('title_str', 'var')
  title_str = '';
end

% find the current (I) object
if isfield(a_md.model_f.f, 'I')
  I = a_md.model_f.I;
else
  I = a_md.model_f;
end

p = getParam(I, 'p');

if p > 1
  a_m_p = plot_abstract(I.m.inf .^ p);
  a_m_label = [ ', m_inf^' num2str(p) ];
else
  a_m_p = plot_abstract;
  a_m_label = '';
end

if isfield(struct(I.f.h), 'f')
  a_h_p = plot_abstract(I.h.inf);
  a_h_label = ', and h_inf ';
else
  a_h_p = plot_abstract;
  a_h_label = '';
end

if isfield(props, 'quiet')
  all_title = title_str;
else
  all_title = [ ', ' a_md.id get(a_md.model_f, 'id') ' m_inf' a_m_label a_h_label title_str ];
end

a_p = ...
    plot_superpose({plot_abstract(I.m.inf, all_title, ...
                                  struct('quiet', 1, 'noTitle', 1, 'fixedSize', [2.5 2], ...
                                         'axisProps', struct('Box', 'off'), ...
                                         'plotProps', struct('LineWidth', 2))), ...
                    a_m_p, a_h_p}, {}, '');
