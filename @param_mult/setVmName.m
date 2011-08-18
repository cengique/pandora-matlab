function a_m = setVmName(a_m, name, props)

% setVmName - Sets the name of voltage signal.
%
% Usage:
%   a_m = setVmName(a_m, name, props)
%
% Parameters:
%   a_m: A param_mult object.
%   name: Name of Vm signal in integrator.
%   props: A structure with any optional properties.
%     recursive: Apply to all child objects.
%		
% Returns:
%   a_m: Updated object.
%
% Description:
%
% Example:
%   >> a_m = setVmName(a_m, 'Vm')
%
% See also: param_act_deriv_v
%
% $Id: setVmName.m 88 2010-04-08 17:41:24Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/05/04

% Copyright (c) 2009 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% TODO: this func should only be in deriv version
% param_func and param_mult should probably be combined?

props = defaultValue('props', struct);

if isfield(props, 'recursive')
  fs_names = fieldnames(a_m.f);
  for f_num = 1:length(fs_names)
    a_m.f.(fs_names{f_num}) = ...
      setVmName(a_m.f.(fs_names{f_num}), name, props);  
  end
end

a_m.param_func = setVmName(a_m.param_func, name, props);