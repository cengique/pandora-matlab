function a_md_model = shiftENa(a_md, shift_E, props)

% shiftENa - Shifts NaT and NaP E values by the given amount.
%
% Usage:
% a_md_model = shiftENa(a_md, shift_E, props)
%
% Parameters:
%   a_md: A model_data_vcs_DmNavTPS object.
%   shift_E: Shift in E to apply.
%   props: A structure with any optional properties (inherited from a_md).
%     onlyModel: If 1, just return scaled model. Do not update a_md. 
%     noUpdate: If 1, set the model in a_md, but do not simulate it
%     		(saves time if there are multiple modifications to model).
%		
% Returns:
%   a_md_model: Updated a_md or the model if props.onlyModel specified.
%
% Description:
%
% Example:
% % Shift from ND96 to ND25 by subtracting 35 mV
% >> a_md = shiftENa(a_md, -35)
%
% See also: model_data_vcs_DmNavTPS
%
% $Id: shiftENa.m 234 2010-10-21 22:06:52Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/07/17
  
% assign model func by default
  a_md_model = get(a_md, 'model_f');

  a_md_model.nat.E = a_md_model.nat.E + shift_E;
  a_md_model.nap.E = a_md_model.nap.E + shift_E;

  if ~ isfield(props, 'onlyModel')
    % update a_md with model
    if ~ isfield(props, 'noUpdate')
      a_md_model = ...
          updateModel(a_md, a_md_model);
    else
      % only set model, do not simulate 
      a_md_model = set(a_md, 'model_f', a_md_model); 
    end
  end
