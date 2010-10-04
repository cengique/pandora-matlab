function params_struct = getParamsStruct(a_ps, props)

% getParamsStruct - Gets the parameters of function as a structure.
%
% Usage:
%   params_struct = getParamsStruct(a_ps, props)
%
% Parameters:
%   a_ps: A param_func object.
%   props: A structure with any optional properties.
%     (passed to getParams).
%		
% Returns:
%   params_struct: Structure with parameter values.
%
% Description:
%
% Example:
% Get absolute parameter values:
%   >> params = getParamsStruct(a_ps)
% Set relative ratios:
%   >> param_ratios = getParamsStruct(a_ps, struct('direct', 1))
%
% See also: getParams, param_func
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2009/06/01

% Copyright (c) 2009 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

props = mergeStructs(props, get(a_ps, 'props'));

param_names = getParamNames(a_ps, props);

% $$$ if isfield(props, 'onlySelect') && props.onlySelect == 1 ...
% $$$       && isfield(props, 'selectParams')
% $$$   param_names = props.selectParams;
% $$$ else
% $$$ end

params_struct = ...
    cell2struct(num2cell(getParams(a_ps, props)), param_names, 2);
