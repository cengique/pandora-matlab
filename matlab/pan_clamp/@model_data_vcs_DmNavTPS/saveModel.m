function filename = saveModel(a_md, name_append, props)

% saveModel - Convenience function to save model at proper location.
%
% Usage:
% filename = saveModel(a_md, name_append, props)
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
% >> plotFigure(saveModel(a_md, 'my model'))
%
% See also: model_data_vcs, voltage_clamp, plot_abstract, plotFigure
%
% $Id: saveModel.m 276 2010-11-09 23:30:35Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/05/31

if ~ exist('props', 'var')
  props = struct;
end

name_append = defaultValue('name_append', '');

splice_dir = ...
    create_dir([ 'splice/' a_md.name ]);

filename = ...
    [splice_dir filesep get(a_md, 'id') '-NaT-NaP-model' name_append '.mat' ];

a_model = get(a_md, 'model_f');
save(filename, 'a_model', '-v7');
end

function dirname = create_dir(dirname)
if ~ exist(dirname, 'dir')
  mkdir(dirname);
end
end