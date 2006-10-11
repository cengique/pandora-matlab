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

col_name_cell = fieldnames(get(db, 'col_idx'));

col = tests2cols(db, param);

%# List of columns with parameter and all tests
cols = [col, (db.num_params + 1):dbsize(db, 2) ];

%# Add invar test name
props = get(db, 'props');
props(1).invarName = [ col_name_cell{col} ];
db = set(db, 'props', props);

%# Get invarValues for these
a_3D_db = invarValues(db, cols, col);
