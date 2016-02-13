function a_pf = setVmName(a_pf, name, props)

% setVmName - Sets the name of voltage signal.
%
% Usage:
%   a_pf = setVmName(a_pf, name, props)
%
% Parameters:
%   a_pf: A param_func object.
%   name: Name of Vm signal in integrator.
%   props: A structure with any optional properties.
%		
% Returns:
%   a_pf: Updated object.
%
% Description:
%
% Example:
%   >> a_pf = setVmName(a_pf, 'Vm')
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

a_pf = setProp(a_pf, 'VmName', name);
