function a_pm = setFunc(a_pm, func_name, func_obj, props)

% setFunc - Sets one of the sub functions in this param_mult.
%
% Usage:
%   a_pm = setFunc(a_pm, func_name, func_obj, props)
%
% Parameters:
%   a_pm: A param_mult object.
%   func_name: Name of one of the existing functions.
%   func_obj: New param_func object.
%   props: A structure with any optional properties.
%		
% Returns:
%   a_pm: Object with new the function.
%
% Description:
%
% Example:
% Set absolute parameter values:
%   >> a_pm = setFunc(a_pm, 'm_inf', f_minf)
%
% See also: param_func, param_mult
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/01/22

% Copyright (c) 2009-2010 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

if isfield(a_pm.f, func_name)
  a_pm.f.(func_name) = func_obj;
else
  disp('Functions:')
  a_pm.f
  error([ 'Cannot find function "' func_name ...
          '" in functions contained (see above).']);
end
