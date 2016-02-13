function value = getParam(a_pf, param_name, props)

% getParam - Gets a parameter value of the function by name.
%
% Usage:
%   value = getParam(a_pf, param_name, props)
%
% Parameters:
%   a_pf: A param_func object.
%   param_name: Name of param to be set.
%   props: A structure with any optional properties.
%     direct: If 1, set parameters directly as relative range ratios (default=1).
%		
% Returns:
%   a_pf: Value of parameter.
%
% Description:
%
% Example:
% Get absolute parameter values:
%   >> a = getParam(a_pf, 'a')
% Get relative ratios:
%   >> a = getParam(a_pf, 'a', struct('direct', 1))
%
% See also: param_func, setParam
%
% $Id: getParam.m 88 2010-04-08 17:41:24Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/04/13

% Copyright (c) 2009-2010 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

% defaults
props = mergeStructs(props, struct('direct', 1));

try
  param_index = tests2cols(a_pf, param_name);
catch
  disp(['Cannot find parameter "' param_name '"?']);
  rethrow(lasterror);
end

% we're doing some unnecessary work here
param_vals = get(a_pf, 'data');
value = param_vals(param_index);

props = mergeStructs(props, get(a_pf, 'props'));

if props.direct == 0
  value = ...
      convertRatios2Params(value, ...
                           mergeStructs(struct('onlyIdx', param_index), ...
                                        props));
end
