function param_names = getParamNames(a_ps, props)

% getParamNames - Gets the parameter names of function.
%
% Usage:
%   param_names = getParamNames(a_ps, props)
%
% Parameters:
%   a_ps: A param_func object.
%   props: A structure with any optional properties.
%     onlySelect: If 1, return only parameters listed in selectParams prop.
%
% Returns:
%   param_names: Cell of parameter names.
%
% Description:
%
% Example:
%   >> param_names = getParamNames(a_ps)
%
% See also: param_func
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2009/12/09

% Copyright (c) 2009 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

props = mergeStructs(defaultValue('props', struct), get(a_ps, 'props'));

param_names = getColNames(a_ps);

if isfield(props, 'onlySelect') && props.onlySelect == 1 ...
      && isfield(props, 'selectParams')
  param_idx = tests2cols(a_ps, props.selectParams);
else
  param_idx = ':';
end

if isfield(props, 'onlySelect')
  param_names = param_names(param_idx);
end

% return row vector always
param_names = param_names(:)';