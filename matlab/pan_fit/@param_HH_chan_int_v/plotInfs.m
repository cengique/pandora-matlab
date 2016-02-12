function a_p = plotInfs(a_chan, title_str, props)

% plotInfs - Plot model m_inf and h_inf curves.
%
% Usage:
% a_p = plotInfs(a_chan, title_str, props)
%
% Parameters:
%   a_chan: A param_HH_chan_int_v object.
%   title_str: (Optional) Text to appear in the plot title.
%   props: A structure with any optional properties.
%     label: Channel name (e.g., 'Na'; default='') 
%     quiet: If 1, only use given title_str.
% 
% Returns:
%   a_p: A plot_abstract object.
%
% Description:
%
% Example:
% >> a_chan = param_HH_chan_int_v(...)
% >> plotFigure(plotInfs(a_chan, 'my model'))
%
% See also: param_act, plot_abstract, plotFigure
%
% $Id: plotInfs.m 276 2010-11-09 23:30:35Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/01/27

props = defaultValue('props', struct);
title_str = defaultValue('title_str', '');

if isfield(props, 'label')
  label = [ '_{' props.label ',\infty}'];
else
  label = '_\infty';  
end

props = ...
    mergeStructsRecursive(props, ...
                          struct('axisProps', ...
                                 struct('Box', 'off')));

% find the current (I) object
I = a_chan.param_mult.f;

p = getParam(a_chan, 'p');

if p > 1
  a_m_p = plot_abstract(I.m.inf .^ p, '', props);
  a_m_label = [ ', m' label '^' num2str(p) ];
else
  a_m_p = plot_abstract(I.m.inf, '', props);
  a_m_label = [ 'm' label ];
end

if isfield(struct(I.h), 'f')
  a_h_p = plot_abstract(I.h.inf);
  a_h_label = [ ', and h' label ' ' ];
else
  a_h_p = plot_abstract;
  a_h_label = '';
end

if isfield(props, 'quiet')
  all_title = title_str;
else
  all_title = [ get(a_chan, 'id') ' ' a_m_label ' ' a_h_label title_str ];
end

a_p = ...
    plot_superpose({set(a_m_p, 'title', all_title), a_h_p}, {}, '');
