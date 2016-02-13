function filename = printFig(a_md, name_append, props)

% printFig - Convenience function to save figure file into proper location.
%
% Usage:
% filename = printFig(a_md, name_append, props)
%
% Parameters:
%   a_md: A model_data_vcs object.
%   name_append: Name to append to file base.
%   props: A structure with any optional properties.
%		
% Returns:
%   filename: Filename with full path.
%
% Description:
%
% Example:
% >> a_md = model_data_vcs(model, data_vc)
% >> plotFigure(printFig(a_md, 'my model'))
%
% See also: model_data_vcs, voltage_clamp, plot_abstract, plotFigure
%
% $Id: printFig.m 276 2010-11-09 23:30:35Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/05/31

if ~ exist('props', 'var')
  props = struct;
end

if ~ exist('name_append', 'var')
  name_append = '';
end

doc_dir = ...
    create_dir([ 'doc/' a_md.name ]);

filename = ...
    [doc_dir filesep get(a_md, 'id') name_append '.eps' ];

print('-depsc2', filename);
end

function dirname = create_dir(dirname)
if ~ exist(dirname, 'dir')
  mkdir(dirname);
end
end