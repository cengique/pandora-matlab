function a_p = plotModelInfs(a_md, title_str, props)

% plotModelInfs - Plot model gate steady-state voltage dependence curves.
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
% >> plotFigure(plotModelInfs(a_md, 'I/V curves'))
%
% See also: model_data_vcs_DmNav, voltage_clamp, plot_abstract, plotFigure
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

model_f = get(a_md, 'model_f');

% find the current (I) object
if isfield(model_f.f, 'I')
  I = model_f.I;
else
  I = model_f;
end

if isfield(props, 'quiet')
  all_title = title_str;
else
  all_title = [ ', ' get(I, 'id') ' time constants ' title_str ];
end

a_p = ...
    { plot_abstract(I.Kf.m.inf .^ 4, all_title, ...
                    struct('noTitle', 1, 'fixedSize', [2.5 2], ...
                           'plotProps', struct('LineWidth', 2))), ...
      plot_abstract(I.Kf.h.inf)};

if isfield(I.Kf.f, 'h2')
  a_p = [ a_p, { plot_abstract(I.Kf.h2.tau) }];
end


a_p = ...
    plot_superpose([a_p, { plot_abstract(I.Ks.m.inf)} ]);
