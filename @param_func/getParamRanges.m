function param_ranges = getParamRanges(a_ps, props)

% getParamRanges - Gets the parameter ranges of function.
%
% Usage:
%   param_ranges = getParamRanges(a_ps, props)
%
% Parameters:
%   a_ps: A param_func object.
%   props: A structure with any optional properties.
%     onlySelect: If 1, return only parameters listed in selectParams prop.
%		
% Returns:
%   param_ranges: 2xn matrix of parameter ranges.
%
% Description:
%
% Example:
% Get parameter ranges:
%   >> param_ranges = getParamRanges(a_ps)
%
% See also: param_func
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/03/04

% Copyright (c) 2010 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

props = mergeStructs(props, get(a_ps, 'props'));

if isfield(props, 'onlySelect') && props.onlySelect == 1 ...
      && isfield(props, 'selectParams')
  param_idx = tests2cols(a_ps, props.selectParams);
else
  param_idx = ':';
end

if isfield(props, 'paramRanges')
  param_ranges = props.paramRanges;
else
  param_ranges = ...
      [ repmat(-Inf, 1, dbsize(a_ps.tests_db, 2)); ...
        repmat(Inf, 1, dbsize(a_ps.tests_db, 2)) ];
end
param_ranges = param_ranges(:, param_idx);

