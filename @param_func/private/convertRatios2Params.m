function param_vals = convertRatios2Params(param_ratios, props)

% convertRatios2Params - Converts parameter values into relative range ratios.
%
% Usage:
%   param_vals = convertRatios2Params(param_ratios, props)
%
% Parameters:
%   param_ratios: Vector of parameter values.
%   props: A structure with any optional properties.
%     onlyIdx: Set only these parameters
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

param_vals = param_ratios;

% convert only if ranges are defined
if isfield(props, 'paramRanges')

  if isfield(props, 'onlyIdx')
    idx = props.onlyIdx;
  else
    idx = ':';
  end

  param_ratios = feval(props.rangeFunc, param_ratios);
  param_abs = props.paramRanges(1, idx) + param_ratios .* ...
      diff(props.paramRanges(:, idx), 1, 1);
  nonnan_idx = ~isnan(param_abs);
  param_vals(nonnan_idx) = param_abs(nonnan_idx);
end