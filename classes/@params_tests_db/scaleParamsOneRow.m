function a_params_db = scaleParamsOneRow(a_db, params, levels)

% scaleParamsOneRow - Scales chosen parameters in a row by multiplying with levels to create a new parameter db with as many rows as values in levels.
%
% Usage:
% a_params_db = scaleParamsOneRow(a_db, params, levels)
%
% Description:
%   Produces rows by multiplying desired params, in the first row of DB, 
% with each value in levels. Then, makeGenesisParFile can be used to generate
% a parameter file from this DB to drive new simulations.
%
%   Parameters:
%	a_db: A params_tests_db object whose first row is subject to modifications.
%	params: Parameters to be varied (see tests2cols for param description).
%	levels: Column vector of parameter value multipliers (1=unity).
%
%   Returns:
%	a_params_db: A db only with params.
%
%   Example:
% Blocks NaF from 0%-100% with 10% increments.
% >> naf_rows_db = scanOneParam(a_db(desired_row, :), 'NaF', 0:0.1:1);
%
% See also: ranked_db/blockedDistances, getParamRowIndices, makeGenesisParFile
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/02/16

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

if ~ iscell(params)
  params = {params};
end

%# Get only first row
a_params_db = onlyRowsTests(a_db, 1, params);
a_params_db = params_tests_db(levels * get(a_params_db, 'data'), ...
			      params, [], {}, [ params{:} ' DB']);

a_params_db = crossProd(delColumns(a_db, params), a_params_db);



