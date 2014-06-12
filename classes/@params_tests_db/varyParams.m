function a_params_db = varyParams(a_db, params, levels, props)

% varyParams - Varies chosen parameters in all rows by given levels.
%
% Usage:
% a_params_db = varyParamsOneRow(a_db, params, levels, props)
%
% Parameters:
%   a_db: A params_tests_db object.
%   params: Parameters to be varied (see tests2cols).
%   levels: Column vector of parameter values to multiply (1=unity)
%	or to replace parameters with (see 'replace' prop).
%   props: A structure with any optional properties.
%	replace: Replace parameter values with levels instead of scaling.
%
% Returns:
%   a_params_db: A db only with params.
%
% Example:
% Blocks NaF from 0%-100% with 10% increments:
% >> naf_rows_db = varyParams(a_db(desired_row, :), 'NaF', 0:0.1:1);
%
% Description:
%   Produces new rows by either multiplying or replacing the desired params
% with each value in levels. Thus, the newly created parameter db will be
% size of levels times bigger. Columns other than parameers will be
% pruned. Then, makeGenesisParFile can be used to generate a parameter file
% from this DB to drive new simulations.
%
% See also: makeGenesisParFile, ranked_db/blockedDistances, getParamRowIndices
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/02/16

% Copyright (c) 2007-2014 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

props = defaultValue('props', struct);

if ~ iscell(params)
  params = {params};
end

% make column vector
levels=levels(:); 

% Select parameters
a_params_db = onlyRowsTests(a_db, ':', params);

% multiply or replace?
new_params = repmat(levels, dbsize(a_params_db));
if ~ isfield(props, 'replace')
  % replicate each row length(levels) times to align with levels
  data = get(a_params_db, 'data');
  index = reshape(repmat(1:size(data, 1), length(levels), 1), ...
                  size(data, 1) * length(levels), 1);
  new_params = new_params .* data(index, :);
end

a_params_db = params_tests_db(new_params, ...
			      params, [], {}, [ params{:} ' DB' ]);
% name
param_names = ...
    cellfun(@(x)[ x ' '], getColNames(onlyRowsTests(a_db, ':', params)), ...
            'UniformOutput', false);

% expand db using fake column(s)
a_params_expand_db = ...
    crossProd(delColumns(a_db, params), ...
              params_tests_db(repmat(NaN, length(levels), ...
                                     dbsize(a_params_db, 2)), params, ...
                              [], {}, [ param_names{:}  ' vary DB']));
a_params_expand_db = delColumns(a_params_expand_db, params);

% combine with new params
a_params_db = ...    
    addParams(a_params_db, getColNames(a_params_expand_db), ...
              get(a_params_expand_db, 'data'));

% Keep original order of params
a_params_db = onlyRowsTests(a_params_db, ':', getParamNames(a_db));
