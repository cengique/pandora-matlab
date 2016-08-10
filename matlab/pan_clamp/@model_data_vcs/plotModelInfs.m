function a_p = plotModelInfs(a_md, title_str, props)

% plotModelInfs - Plot model m_inf and h_inf curves.
%
% Usage:
% a_p = plotModelInfs(a_md, title_str, props)
%
% Parameters:
%   a_md: A model_data_vcs object.
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
% >> a_md = model_data_vcs(model, data_vc)
% >> plotFigure(plotModelInfs(a_md, 'my model'))
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

% find the current (I) object
if isfield(a_md.model_f.f, 'Vm')
  I = a_md.model_f.Vm.I;
elseif isfield(a_md.model_f.f, 'Vm_Vw')
  I = a_md.model_f.Vm_Vw.I;
elseif isfield(a_md.model_f.f, 'I')
  I = a_md.model_f.I;
else
  I = a_md.model_f;
end

if isfield(I.m.props, 'inf_func')
  m_inf = I.m.props.inf_func(I.m);
else
  m_inf = I.m.inf;
end

try get(I, 'h') %ismember(getColNames(I), 'h')
    if isfield(I.h.props, 'inf_func')
      h_inf = I.h.props.inf_func(I.h);
    elseif isfield(struct(I.f.h), 'f')
      h_inf = I.h.inf;
    else
        h_inf = [];
    end
catch exception
  h_inf = [];
end
 

plot_props = ...
    mergeStructs(props, ...
                 struct('quiet', 1, 'noTitle', 1, 'fixedSize', [2.5 2], ...
                        'grid', 1, 'plotProps', struct('LineWidth', 2)));

p = getParam(I, 'p');

if p > 1
  a_m_p = plot_abstract(m_inf .^ p, '', plot_props);
  a_m_label = [ ', m_inf^' num2str(p) ];
else
  a_m_p = plot_abstract(m_inf, '', plot_props);
  a_m_label = 'm_inf';
end

if ~isempty(h_inf)
  a_h_p = plot_abstract(h_inf);
  a_h_label = ', and h_inf ';
else
  a_h_p = plot_abstract;
  a_h_label = '';
end

if isfield(props, 'quiet')
  all_title = title_str;
else
  all_title = [ ', ' a_md.id get(a_md.model_f, 'id') ' ' a_m_label ' ' a_h_label title_str ];
end

a_p = ...
    plot_superpose({set(a_m_p, 'title', all_title), a_h_p}, {}, '');
