function a_md = updateModel(a_md, model_f, props)

% updateModel - Plot model m_inf and h_inf curves.
%
% Usage:
% a_md = updateModel(a_md, model_f, props)
%
% Parameters:
%   a_md: A model_data_vcs object.
%   model_f: param_func or subclass object that holds the new model function.
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
% $Id: updateModel.m 234 2010-10-21 22:06:52Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/14

if ~ exist('props', 'var')
  props = struct;
end

a_md.model_data_vcs = updateModel(a_md.model_data_vcs, model_f);  % simulate model
a_md.md_pre = updateModel(a_md.md_pre, model_f);  % simulate model
