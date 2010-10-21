function a_p = plotModelTaus(a_md, title_str, props)

% plotModelTaus - Plot I/V curves comparing model and data.
%
% Usage:
% a_p = plotModelTaus(a_md, title_str, props)
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
% >> plotFigure(plotModelTaus(a_md, 'I/V curves'))
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
  all_title = [ ', ' a_md.id get(a_md.model_f, 'id') ' time constants ' title_str ];
end

% find the current (I) object
if isfield(a_md.model_f.f, 'I')
  I = a_md.model_f.I;
else
  I = a_md.model_f;
end

a_p = { plot_abstract(I.m.tau, all_title) };

if isfield(struct(I.f.h), 'f')
  a_p = [ a_p, { plot_abstract(I.h.tau) }];
end

if isfield(I.f, 'h2')
  a_p = [ a_p, { plot_abstract(I.h2.tau) }];
end

a_p = ...
    plot_superpose(a_p);

a_p.props = ...
    struct('noTitle', 1, 'fixedSize', [2.5 2], ...
           'plotProps', struct('LineWidth', 2));
