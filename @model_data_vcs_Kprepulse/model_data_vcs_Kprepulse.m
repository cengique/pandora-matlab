function a_md = model_data_vcs_Kprepulse(model_f, data_vc, pre_data_vc, id, props)

% model_data_vcs_Kprepulse - Keeps model and data for K recordings with and without an inactivation prepulse.
%
% Usage:
% a_md = model_data_vcs_Kprepulse(model_f, data_vc, pre_data_vc, id, props)
%
% Parameters:
%   model_f: A param_func model of fast and slow K currents summed.
%   data_vc, pre_data_vc: Normal and prepulse voltage_clamp data objects.
%   id: Identification string.
%   props: A structure with any optional properties.
%
% Returns a structure object with the following fields:
%   model_data_vcs, md_pre.
%
% Description:
%   For tasks such as plotting comparison of model to data and generating
% initial fits for model. Can also have a GUI here for fitting.
%
% General methods of model_data_vcs_Kprepulse objects:
%   model_data_vcs_Kprepulse		- Construct a new model_data_vcs_Kprepulse object.
%
% Additional methods:
%   See methods('model_data_vcs_Kprepulse')
%
% See also: voltage_clamp, param_func
%
% $Id: model_data_vcs_Kprepulse.m 132 2010-06-22 13:32:03Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/18

% Copyright (c) 2007-2010 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% TODO: 
% - or not make this a subclass and hold the MDs directly?
% - pass model_f already added? is there a way to label the currents?

if nargin == 0 % Called with no params
  a_md = struct;
  a_md.md_pre = model_data_vcs;
  a_md = class(a_md, 'model_data_vcs_Kprepulse', model_data_vcs);
elseif isa(model_f, 'model_data_vcs_Kprepulse') % copy constructor?
  a_md = model_f;
else
  if ~ exist('props', 'var')
    props = struct;
  end
  
  a_md = struct;
  a_md.md_pre = ...
      model_data_vcs(model_f, pre_data_vc, [ id 'w/ inact prepulse'], props);
  a_md = class(a_md, 'model_data_vcs_Kprepulse', ...
               model_data_vcs(model_f, data_vc, [ id 'w & w/o inact prepulse'], props));
end
