function a_ps = setParams(a_ps, param_vals, props)

% setParams - Sets the parameters of function.
%
% Usage:
%   a_ps = setParams(a_ps, param_vals, props)
%
% Parameters:
%   a_ps: A param_func object.
%   param_vals: Vector of new parameter values.
%   props: A structure with any optional properties.
%     direct: If 1, set parameters directly as relative range ratios.
%		
% Returns:
%   a_ps: Object with new parameter values.
%
% Description:
%
% Example:
% Set absolute parameter values:
%   >> a_ps = setParams(a_ps, [10 20])
% Set relative ratios:
%   >> a_ps = setParams(a_ps, [.4 .7], struct('direct', 1))
%
% See also: param_func
%
% $Id: func.m 1174 2009-03-31 03:14:21Z cengiz $
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

param_vals = param_vals(:)';            % row vector only

if ~ isfield(props, 'direct')
  param_vals = ...
      convertParams2Ratios(param_vals, get(a_ps, 'props'));
end

a_ps = set(a_ps, 'data', param_vals);