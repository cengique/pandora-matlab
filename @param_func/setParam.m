function a_pf = setParam(a_pf, param_name, value, props)

% setParam - Sets a parameter of the function by name.
%
% Usage:
%   a_pf = setParam(a_pf, param_name, value, props)
%
% Parameters:
%   a_pf: A param_func object.
%   param_name: Name of param to be set.
%   value: New parameter value.
%   props: A structure with any optional properties.
%     direct: If 1, set parameters directly as relative range ratios.
%		
% Returns:
%   a_pf: Object with new parameter values.
%
% Description:
%
% Example:
% Set absolute parameter values:
%   >> a_pf = setParam(a_pf, 'a', [20])
% Set relative ratios:
%   >> a_pf = setParam(a_pf, 'a', [.7], struct('direct', 1))
%
% See also: param_func
%
% $Id: func.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/01/18

% Copyright (c) 2009 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

try
  param_index = tests2cols(a_pf, param_name);
catch
  disp(['Cannot find parameter "' param_name '"?']);
  rethrow(lasterror);
end

props = mergeStructs(props, get(a_pf, 'props'));

if ~ isfield(props, 'direct')
  value = ...
      convertParams2Ratios(value, ...
                           mergeStructs(struct('onlyIdx', param_index), ...
                                        props));
end

% we're doing some unnecessary work here
param_vals = get(a_pf, 'data');
param_vals(param_index) = value;

a_pf = set(a_pf, 'data', param_vals);