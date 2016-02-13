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
% $Id: plotModelInfs.m 276 2010-11-09 23:30:35Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/12

if ~ exist('props', 'var')
  props = struct;
end

if ~ exist('title_str', 'var')
  title_str = '';
end

% plot nat properties since nap mirrors nat.m
a_model = get(a_md, 'model_f');

fake_md = a_md.model_data_vcs;
fake_md.model_f = a_model.nat;
a_p = plotModelInfs(fake_md, title_str, props);
