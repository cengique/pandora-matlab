function a_3D_db = invarParam(db, param, props)

% invarParam - Generates a 3D database of invariant values of a parameter and all test columns. 
%
% Usage:
% a_3D_db = invarParam(db, param, props)
%
% Parameters:
%   db: A tests_db object.
%   param: A parameter name/column number. It can be empty [], meaning to
%   	find all unique combinations of parameters.
%   props: A structure with any optional properties.
%     removeRedun: If 1 (default), clean database by removing redundant
%     	sets of parameters.
%     removeCol: If removeRedun == 1, name of parameter column to remove 
%	if found. Default: 'trial'.
%     (others passed to tests_db/invarValues)
%		
% Description:

%   Finds partitions (pages) of the database with varying values of selected
% parameter while the rest of the "background" parameters are constant
% (invariant). Different unique backgrounds will be placed in separate
% partitions; i.e., pages of the returned tests_3D_db. It will include the
% selected parameter and all tests. Removes the parameter column named
% 'trial' before this operation since it will be unique for each row. It
% will also remove redundant parameter sets to have one of each unique
% combination. You may need to average rows before running this. See
% meanDuplicateRows.
%
%   Returns:
%	a_3D_db: A tests_3D_db object of organized values.
%
% See also: tests_db/invarValues, tests_3D_db, corrCoefs, tests_3D_db/plotPair, meanDuplicateRows
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
props = defaultValue('props', struct);
col_name_cell = fieldnames(get(db, 'col_idx'));

if getFieldDefault(props, 'removeRedun', 1) == 1
  % Remove trial column from parameters that define character of data
  trial_col = strmatch(getFieldDefault(props, 'removeCol', 'trial'), col_name_cell);
  
  % Remove the trial parameter before the redundancy check
  no_trial_cols = false(1, dbsize(db, 2));
  no_trial_cols(1:num_params) = true(1);
  no_trial_cols(trial_col) = false(1);

  % before everything, make sure database has no redundant parameter sets
  [unique_rows unique_idx] = ...
      uniqueValues(data(:, no_trial_cols));
  if size(unique_rows, 1) < size(data, 1)
    warning(['Removing redundant parameter sets from the DB.']);
    db = set(db, 'data', data(unique_idx, :));
  end
end

col = tests2cols(db, param);

% List of columns with parameter and all tests
cols = [col, (db.num_params + 1):dbsize(db, 2) ];

% Add invar test name
db_props = get(db, 'props');
db_props(1).invarName = [ col_name_cell{col} ];
db = set(db, 'props', db_props);

% Get invarValues for these
a_3D_db = invarValues(db, cols, col, props);
