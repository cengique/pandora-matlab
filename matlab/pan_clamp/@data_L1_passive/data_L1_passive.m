function a_data = data_L1_passive(data_vc, model_f, id, props)

% data_L1_passive - Holds passive recordings from L1 cells.
%
% Usage:
% a_data = data_L1_passive(data_vc, model_f, id, props)
%
% Parameters:
%   data_vc: A voltage_clamp object with the data.
%   model_f: Passive model to fit the data (e.g., param_Re_Ce_cap_leak_act_int_t)
%   id: Identification string.
%   props: A structure with any optional properties.
%
% Returns a structure object with the following fields:
%   model_f, data_vc.
%
% Description:
%   Encapsulates the data and provides functions that find fits and return plots and
% statistics.
%
% General methods of data_L1_passive objects:
%   data_L1_passive		- Construct a new data_L1_passive object.
%
% Additional methods:
%   See methods('data_L1_passive')
%
% See also: voltage_clamp, param_func, param_Re_Ce_cap_leak_act_int_t
%
% $Id: data_L1_passive.m 234 2010-10-21 22:06:52Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/21

% Copyright (c) 2007-2010 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% TODO: 
% - this can be a subclass of model_data_vcs

if nargin == 0 % Called with no params
  a_data = struct;
  a_data.model_f = param_func;
  a_data.data_vc = voltage_clamp;
  a_data.id = '';
  a_data = class(a_data, 'data_L1_passive');
elseif isa(data_vc, 'data_L1_passive') % copy constructor?
  a_data = data_vc;
else
  if ~ exist('props', 'var')
    props = struct;
  end

  a_data = struct;
  a_data.model_f = defaultValue('model_f', param_func);
  a_data.data_vc = data_vc;
  a_data.id = defaultValue('id', [ get(a_data.data_vc, 'id') ]);

  a_data = class(a_data, 'data_L1_passive');
end
