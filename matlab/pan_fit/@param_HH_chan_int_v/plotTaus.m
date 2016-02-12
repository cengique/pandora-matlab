function a_p = plotTaus(a_chan, title_str, props)

% plotTaus - Plot model m_inf and h_inf curves.
%
% Usage:
% a_p = plotTaus(a_chan, title_str, props)
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
% >> plotFigure(plotTaus(a_chan, 'my model'))
%
% See also: param_act, plot_abstract, plotFigure
%
% $Id: plotTaus.m 276 2010-11-09 23:30:35Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/01/27

props = defaultValue('props', struct);
title_str = defaultValue('title_str', '');

if isfield(props, 'quiet')
  all_title = title_str;
else
  all_title = [ get(a_chan, 'id')  ' time constants ' title_str ];
end

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

a_p = { plot_abstract(I.m.tau, all_title) };

if isfield(struct(I.h), 'f')
  a_p = [ a_p, { plot_abstract(I.h.tau) }];
end

if isfield(I, 'h2')
  a_p = [ a_p, { plot_abstract(I.h2.tau) }];
end

a_p = ...
    plot_superpose(a_p);

a_p.props = ...
    mergeStructs(props, ...
                 struct('noTitle', 1, 'fixedSize', [2.5 2], ...
                        'grid', 1, 'plotProps', struct('LineWidth', 2)));
