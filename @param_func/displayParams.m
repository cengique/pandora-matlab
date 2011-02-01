function disp_cell = displayParams(a_pf, props)

% displayParams - Display parameter values.
%
% Usage:
%   disp_cell = displayParams(a_pf)
%
% Parameters:
%   a_pf: A param_func object.
%   props: A structure with any optional properties.
%     lastParams: show changes with these param values.
%     lastParamsF: get lastParams from this function.
%     confInt: show nx2 matrix of confidence intervals.
%     (Rest passed to getParams, etc)
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/04

% Copyright (c) 2010 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Handle differently if an array of DBs
if length(a_pf) > 1
  disp(a_pf);
  return;
end

props = defaultValue('props', struct);

param_struct = getParamsStruct(a_pf, props);

disp_cell = [ getParamNames(a_pf, props)', struct2cell(param_struct) ];
disp_cell = [ {'Param', 'Value'}; disp_cell ];

if isfield(props, 'lastParamsF')
  props.lastParams = getParams(props.lastParamsF, props);
end

if isfield(props, 'lastParams')
  param_diff = getParams(a_pf, props) - props.lastParams;
  disp_cell = [ disp_cell, [ {'Diff'}; num2cell(param_diff(:)) ] ];
end

if isfield(props, 'confInt')
  int_str = ...
      cellfun(@(x,y) sprintf('(%f, %f)', x, y), ...
              num2cell(props.confInt(:, 1)), ...
              num2cell(props.confInt(:, 2)), 'UniformOutput', false);
  disp_cell = [ disp_cell, [ {'95% conf. int.'}; int_str ] ];
end

if isfield(props, 'relConfInt')
  int_str = ...
      cellfun(@(x) sprintf('+/- %g', x), num2cell(props.relConfInt), 'UniformOutput', false);
  disp_cell = [ disp_cell, [ {'95% rel. conf.'}; int_str ] ];
end
