function a_md = updateModel(a_md, model_f, props)

% updateModel - Simulate and save new model into object.
%
% Usage:
% a_md = updateModel(a_md, model_f, props)
%
% Parameters:
%   a_md: A model_data_vcs object.
%   model_f: (optional) param_func or subclass object that holds the new
%   	     model function. If not given, existing model is simulated.
%   props: A structure with any optional properties.
%		
% Returns:
%   a_md: Updated object.
%
% Description:
%   Simulates the model to update the model_vc contained.
%
% Example:
% >> a_md = model_data_vcs(model_f, data_vc)
% >> a_md = updateModel(a_md, new_model_f))
%
% See also: model_data_vcs
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/14

if ~ exist('props', 'var')
  props = struct;
end

a_md.model_f = defaultValue('model_f', a_md.model_f);
a_md.model_vc = simModel(a_md.data_vc, a_md.model_f);  % simulate model
