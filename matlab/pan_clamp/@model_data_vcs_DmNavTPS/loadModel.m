function a_md_model = loadModel(a_md, name_append, props)

% loadModel - Convenience function to load model from proper location.
%
% Usage:
% filename = loadModel(a_md, name_append, props)
%
% Parameters:
%   a_md: A model_data_vcs object.
%   name_append: Name to append to file base.
%   props: A structure with any optional properties.
%     onlyModel: If 1, just return loaded model. Do not update a_md. 
%		
% Returns:
%   a_md_model: Updated a_md or the model if props.onlyModel specified.
%
% Description:
%
% Example:
% >> a_md = loadModel(a_md, 'my model')
%
% See also: model_data_vcs, voltage_clamp, plot_abstract, plotFigure
%
% $Id: loadModel.m 276 2010-11-09 23:30:35Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/07/04

props = defaultValue('props', struct);
name_append = defaultValue('name_append', '');

% assign model func by default
a_md_model = ...
    getfield(load([ 'splice/' a_md.name filesep get(a_md, 'id') ...
                    '-NaT-NaP-model' name_append '.mat' ]), 'a_model');

if ~ isfield(props, 'onlyModel')
  % update a_md with model
  a_md_model = ...
      updateModel(a_md, a_md_model);
end

end