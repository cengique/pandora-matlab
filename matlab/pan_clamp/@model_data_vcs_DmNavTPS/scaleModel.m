function a_md_model = scaleModel(a_md, nat_gmax, props)

% scaleModel - Scale nat and nap gmax's to new nat gmax.
%
% Usage:
% a_md_model = scaleModel(a_md, nat_gmax, props)
%
% Parameters:
%   a_md: A model_data_vcs object.
%   nat_gmax: New gmax value for NaT fucntion.
%   props: A structure with any optional properties.
%     onlyModel: If 1, just return scaled model. Do not update a_md. 
% 
% Returns:
%   a_md_model: Updated a_md or the model if props.onlyModel specified.
%
% Description:
%   Scales NaP gmax based on new NaT gmax value.
%
% Example:
% >> a_md = scaleModel(a_md, 'my model')
%
% See also: model_data_vcs, voltage_clamp, plot_abstract, plotFigure
%
% $Id: scaleModel.m 276 2010-11-09 23:30:35Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/07/13

props = defaultValue('props', struct);

% assign model func by default
a_md_model = get(a_md, 'model_f');

gmax_ratio = nat_gmax / a_md_model.nat.gmax.data;
a_md_model.nat.gmax = nat_gmax;
a_md_model.nap.gmax = a_md_model.nap.gmax.data * gmax_ratio;

if ~ isfield(props, 'onlyModel')
  % update a_md with model
  a_md_model = ...
      updateModel(a_md, a_md_model);
end

end