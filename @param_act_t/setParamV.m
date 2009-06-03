function a_ps = setParamV(a_ps, V_pre, V_now, props)

% setParamV - Sets the function parameters using the pre and post voltage values.
%
% Usage:
%   a_ps = setParamV(a_ps, V_pre, V_now, props)
%
% Parameters:
%   a_ps: A param_act_t object.
%   V_pre, V_now: Previous and current holding voltages used to find values of
%   		m0 and minf.
%   props: A structure with any optional properties.
%		
% Returns:
%   a_ps: Contains updated parameters.
%
% Description:
%
% Example:
% Set params based on holding and votlage step:
%   >> a_ps = setParamV(a_ps, -90, 40)
%
% See also: param_act, param_tau_v, param_func
%
% $Id: func.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2009/06/02

% Copyright (c) 2009 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

a_ps = setParams([f(a_ps.m_inf, V_pre), f(a_ps.m_inf, V_now), ...
                  f(a_ps.tau, V_now)]);
