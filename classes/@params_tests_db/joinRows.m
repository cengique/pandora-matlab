function a_db = joinRows(db, with_db, props)

% joinRows - Joins the rows of the given db with rows of with_db with matching
%  	RowIndex values.
%
% Usage:
% a_db = joinRows(db, with_db, props)
%
% Description:
%   Takes the desired columns in with_db with rows having a 
% row index and joins them next to dedired columns from the current db. 
% Assumes each row index only appears once in with_db. The created
% db preserves the ordering of with_db.
%
%   Parameters:
%	db: A param_tests_db object.
%	with_db: A tests_db object with a RowIndex column.
%	props: A structure with any optional properties.
%	  indexColName: (Optional) Name of row index column (default='RowIndex').
%		
%   Returns:
%	a_db: A params_tests_db object.
%
% See also: tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/16

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% after removing num_params calculation, this method is a redundant placeholder
if ~exist('props', 'var')
  props = struct;
end

% delegate the main job to tests_db/joinRows
joined_db = ...
    joinRows(db.tests_db, with_db, props);

% afterwards, calculate total parameter number and shift columns if
% necessary
all_param_names = getParamNames(db);

% combine with params from with_db
if isa(with_db, 'params_tests_db')
  all_param_names = union(all_param_names, getParamNames(with_db));
end

% choose only params that appear in the output
joined_col_names = getColNames(joined_db);
output_param_names = intersect(all_param_names, joined_col_names);
rest_col_names = setdiff(joined_col_names, output_param_names);
num_params = length(output_param_names);

% reorder to have params in the start
joined_db = ...
    onlyRowsTests(joined_db, ':', { output_param_names{:}, rest_col_names{:}});

% construct new params_tests_db object with correct num_params
a_db = params_tests_db(num_params, ...
		       joined_db, ...
		       get(db, 'props'));
