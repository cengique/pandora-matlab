function param_vals = convertRatios2Params(param_ratios, props)

% convertRatios2Params - Converts parameter values into relative range ratios.
%
% Usage:
%   param_vals = convertRatios2Params(param_ratios, props)
%
% Parameters:
%   param_ratios: Vector of parameter values.
%   props: A structure with any optional properties.
%		
% Returns:
%   param_vals: Vector of updated parameter values.
%
% Description:
%
% Example:
%   >> new_params = convertRatios2Params([.2 .3 .4], a_ps.props)
% This will return actual parameter values for the ratios given.
%
% See also: param_func
%
% $Id: convertRatios2Params.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2009/06/01

% Copyright (c) 2009 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

param_vals = param_ratios;

% convert only if ranges are defined
if isfield(props, 'paramRanges')
  param_ratios = feval(props.rangeFunc, param_ratios);
  param_abs = props.paramRanges(1, :) + param_ratios .* ...
      diff(props.paramRanges, 1, 1);
  nonnan_idx = ~isnan(param_abs);
  param_vals(nonnan_idx) = param_abs(nonnan_idx);
end