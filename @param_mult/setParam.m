function a_pf = setParam(a_pf, param_name, value, props)

% setParam - Sets a parameter of the function or sub functions by name.
%
% Usage:
%   a_pf = setParam(a_pf, param_name, value, props)
%
% Parameters:
%   a_pf: A param_func object.
%   param_name: Name of param to be set. Sub-function parameters
%   	are found by prepending the subfunction name with an underscore
%   	(e.g., 'Vm_p' will look for the parameter fs.Vm.p).
%   value: New parameter value.
%   props: A structure with any optional properties.
%     (Passed to param_func/setParam)
%		
% Returns:
%   a_pf: Object with new parameter values.
%
% Description:
%
% Example:
% Set immediate parameter values:
%   >> a_pf = setParam(a_pf, 'a', [20])
% Set subfunction parameters:
%   >> a_pf = setParam(a_pf, 'Vm_Re', [20])
%
% See also: param_func/setParam
%
% $Id: setParam.m 88 2010-04-08 17:41:24Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2015/05/19

% Copyright (c) 2015 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

try
  param_index = tests2cols(a_pf, param_name);
  a_pf.param_func = setParam(a_pf.param_func, param_name, value, props);
catch
  subfunc_names = fieldnames(a_pf.f);
  % look for subfunction name at the start of parameter name
  found = cell2mat(regexp(param_name, subfunc_names)) == 1;
  assert(sum(found) == 1, ...
         ['Cannot match parameter to exactly one subfunction ' ...
          'name.']);
  subfunc_name = subfunc_names{find(found)};
  % delegate to subfunc only with the remaining part of the
  % parameter (also delete the underscore)
  a_pf.f.(subfunc_name) = ...
      setParam(a_pf.f.(subfunc_name), ...
               param_name((length(subfunc_name) + 2):end), value, props);
end

