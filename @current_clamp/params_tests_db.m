function a_db = params_tests_db(a_cc, props)

% params_tests_db - Extract measurement results.
%
% Usage:
% a_db = params_tests_db(a_cc, props)
%
% Parameters:
%   a_cc: A cip_trace object.
%   props: A structure with any optional properties.
%     stepNum: Current step to get results for (default=2).
%     paramsStruct: Contains parameter names and values that are constant
%     		    for these traces.
%     paramsVary: Contains parameter names and their varying values for
%     		    each of these traces in a structure array (e.g.,
%     		    struct('Na', {10, 50 ,100}))
%
% Returns:
%   a_db: A params_tests_db with results collected from getResults
%
% Description:
%   Selects cip_level_pA as the only parameter. 
%
% See also: getResults, cip_trace, trace, spike_shape
%
% $Id: params_tests_db.m 818 2007-08-28 20:28:51Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/02/23

% Copyright (c) 20011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

props = ...
    mergeStructs(defaultValue('props', struct), get(a_cc, 'props'));

[res profs] = getResults(a_cc, props);

a_db = struct2DB(res);

if isfield(props, 'paramsStruct')
  num_rows = dbsize(a_db, 1);
  param_names = fieldnames(props.paramsStruct);
  num_params = length(param_names);
  % put const params first
  a_db = addColumns(tests_db(repmat(cell2mat(struct2cell(props.paramsStruct))', ...
                                    num_rows, 1), param_names, {}, ''), a_db);
else
  num_params = 0;
end

if isfield(props, 'paramsVary')
  param_names = fieldnames(props.paramsVary);
  num_params = num_params + length(param_names);
  % then varying params
  all_vals = ...
      cell2mat(struct2cell(props.paramsVary));
  param_vals = cell(1, num_params);
  for param_num = 1:num_params
    param_vals{param_num} = all_vals(param_num, :);
  end
  a_db = addColumns(tests_db(combvec(param_vals{:})', ...
                             param_names, {}, ''), a_db);
end

% add cip_level_pA as param
a_db = params_tests_db(num_params + 1, a_db, props);
