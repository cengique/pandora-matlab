function obj = delColumns(obj, tests)

% delColumns - Deletes columns from tests_db.
%
% Usage:
% obj = delColumns(obj, tests)
%
% Description:
%   Deletes test columns from the database and returns the new DB.
%   This operation is expensive in the sense that the whole database matrix
%   needs to be copied just to delete a 
%   single column. The method of allocating a matrix, filling it up, and
%   then providing it to the tests_db constructor is the preferred method 
%   of creating tests_db objects. This method may be used for 
%   measures obtained by operating on raw measures.
%
%   Parameters:
%	obj: A tests_db object.
%	tests: Numbers or names of tests (see tests2cols)
%		
%   Returns:
%	obj: The tests_db object that is missing the columns.
%
% See also: allocateRows, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/10/06

cols = tests2cols(obj, tests);
mask = true(1, dbsize(obj, 2));

%# delete the columns
obj.data(:, cols, :) = [];

%# Update the meta-data
col_idx = get(obj, 'col_idx');
test_names = fieldnames(col_idx);

%# remove the names
mask(cols) = false;
test_names = {test_names{mask}};

%# Make new col_idx
new_col_idx = makeIdx(test_names);
obj = set(obj, 'col_idx', new_col_idx);
