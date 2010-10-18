function a_md = model_data_vcs(model_f, data_vc, id, props)

% model_data_vcs - Combines model description that fits a voltage clamp data.
%
% Usage:
% a_md = model_data_vcs(model_f, data_vc, id, props)
%
% Parameters:
%   model_f: A param_func object with the model.
%   data_vc: A voltage_clamp object with the data.
%   id: Identification string.
%   props: A structure with any optional properties.
%
% Returns a structure object with the following fields:
%   model_f, data_vc.
%
% Description:
%   For tasks such as plotting comparison of model to data and generating
% initial fits for model. Can also have a GUI here for fitting.
%
% General methods of model_data_vcs objects:
%   model_data_vcs		- Construct a new model_data_vcs object.
%
% Additional methods:
%   See methods('model_data_vcs')
%
% See also: voltage_clamp, param_func
%
% $Id: model_data_vcs.m 132 2010-06-22 13:32:03Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/11

% Copyright (c) 2007-2010 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 % Called with no params
  a_md = struct;
  a_md.model_f = param_func;
  a_md.model_vc = voltage_clamp;
  a_md.data_vc = voltage_clamp;
  a_md.id = '';
  a_md = class(a_md, 'model_data_vcs', trace);
elseif isa(model_f, 'model_data_vcs') % copy constructor?
  a_md = model_f;
else
  if ~ exist('props', 'var')
    props = struct;
  end
  
  a_md = struct;
  a_md.model_f = model_f;
  a_md.model_vc = simModel(data_vc, model_f);  % simulate model
  a_md.data_vc = data_vc;
  a_md.id = defaultValue('id', [ get(a_md.model_f, 'id') ' vs. ' get(a_md.data_vc, 'id')]);

  a_md = class(a_md, 'model_data_vcs');
end
