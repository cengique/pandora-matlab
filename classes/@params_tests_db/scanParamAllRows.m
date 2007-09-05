function a_params_db = scanParamAllRows(a_db, param, min_val, max_val, num_levels, props)

% scanParamAllRows - Scans given parameter range for each row in DB.
%
% Usage:
% a_params_db = scanParamAllRows(a_db, param, min_val, max_val, num_levels, props)
%
% Description:
%   Produces rows by replacing the desired parameter value, in all rows of DB, 
% with num_levels values between the given boundaries, min_val and max_val. 
% This results in a DB with num_levels times more rows than the original DB. 
% Then, makeGenesisParFile can be used to generate a parameter file from 
% this DB to drive new simulations.
%
%   Parameters:
%	a_db: A params_tests_db object whose first row is subject to modifications.
%	param: The parameter to be varied (see tests2cols for param description).
%	min_val, max_val: The low and high boundaries for the parameter value.
%	num_levels: Number of levels to produce, including the boundaries.
%	props: A structure with any optional properties.
%	  renameTrial: If given, the 'trial' column is renamed to this name.
%	  levelFunc: Use this function to get the parameter range with 
%		feval(levelFunc, min_val, max_val, num_levels). Example: 'logLevels'
%
%   Returns:
%	a_params_db: A db only with params.
%
%   Example:
% Sets NaF to given range with 100 levels:
% >> naf_rows_db = scanParamAllRows(a_db(desired_rows, :), 'NaF', 0, 1000, 100);
%
% See also: makeGenesisParFile, scaleParamsOneRow, ranked_db/blockedDistances, getParamRowIndices, logLevels
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/02/16

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~exist('props')
  props = struct;
end

if isfield(props, 'levelFunc')
  levels = feval(props.levelFunc, min_val, max_val, num_levels);
else
  %# O/w use aritmetic series
  levels = min_val + (0:(num_levels - 1))' * (max_val - min_val) / (num_levels - 1);
end

param_name = getColNames(onlyRowsTests(a_db, ':', param));

%# Create params DB with desired values
a_params_db = params_tests_db(levels, param_name, [], {}, [ param_name ' DB']);

%# Get cross product with original DB with the param removed
a_params_db = crossProd(delColumns(a_db, param), a_params_db);

%# Keep order of params
a_params_db = vertcat(onlyRowsTests(a_db, [], ':'), a_params_db);

if isfield(props, 'renameTrial')
  a_params_db = renameColumns(a_params_db, 'trial', props.renameTrial);
end

end