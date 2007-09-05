function a_3D_db = invarParam(db, param)

% invarParam - Generates a 3D database of invariant values of a parameter and all test columns. 
%
% Usage:
% a_3D_db = invarParam(db, param)
%
% Description:
%   Finds all combinations when the rest of the parameters are fixed,
% and saves the variation of the selected parameter and all tests in
% a new database.
%
%   Parameters:
%	db: A tests_db object.
%	param: A parameter name/column number
%		
%   Returns:
%	a_3D_db: A tests_3D_db object of organized values.
%
% See also: invarValues, tests_3D_db, corrCoefs, tests_3D_db/plotPair
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/07

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

data = get(db, 'data');
num_params = get(db, 'num_params');

%# Remove trial column from parameters that define character of data
col_name_cell = fieldnames(get(db, 'col_idx'));
trial_col = strmatch('trial', col_name_cell);

%# Remove the trial parameter before the redundancy check
log_cols = false(1, dbsize(db, 2));
log_cols(1:num_params) = true(1);
log_cols(trial_col) = false(1);

% before everything, make sure database has no redundant parameter sets
[unique_rows unique_idx] = ...
    uniqueValues(data(:, log_cols));
if size(unique_rows, 1) < size(data, 1)
    warning(['Removing redundant parameter sets from the DB.']);
    db = set(db, 'data', data(unique_idx, :));
end

col = tests2cols(db, param);

%# List of columns with parameter and all tests
cols = [col, (db.num_params + 1):dbsize(db, 2) ];

%# Add invar test name
props = get(db, 'props');
props(1).invarName = [ col_name_cell{col} ];
db = set(db, 'props', props);

%# Get invarValues for these
a_3D_db = invarValues(db, cols, col);
