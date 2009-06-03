function param_vals = getParams(a_ps, props)

% getParams - Gets the parameters of function.
%
% Usage:
%   param_vals = getParams(a_ps, props)
%
% Parameters:
%   a_ps: A param_func object.
%   props: A structure with any optional properties.
%     direct: If 1, return parameters directly as relative range ratios.
%		
% Returns:
%   param_vals: Vector of parameter values.
%
% Description:
%
% Example:
% Get absolute parameter values:
%   >> params = getParams(a_ps)
% Set relative ratios:
%   >> param_ratios = getParams(a_ps, struct('direct', 1))
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

param_vals = get(a_ps, 'data');

if ~ isfield(props, 'direct')
  param_vals = convertRatios2Params(param_vals, get(a_ps, 'props'));
end
