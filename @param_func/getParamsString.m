function param_str = getParamsString(a_ps, props)

% getParamsString - Returns a string with all parameter-name value pairs.
%
% Usage:
%   param_str = getParamsString(a_ps, props)
%
% Parameters:
%   a_ps: A param_func object.
%   props: A structure with any optional properties.
%     (passed to getParams).
%		
% Returns:
%   param_str: String of param name=val pairs.
%
% Description:
%
% Example:
%   >> params = getParamsString(a_ps)
%
% See also: param_func
%
% $Id: getParamsString.m 88 2010-04-08 17:41:24Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/03

% Copyright (c) 2009-2010 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

param_vals = getParams(a_ps, props);
param_names = getParamNames(a_ps);

param_str = '';
for i = 1:length(param_names)
  if ~ isempty(param_str), param_str = [ param_str ', ' ]; end
  param_str = [ param_str param_names{i} '=' sprintf('%.2e', param_vals(i)) ];
end
