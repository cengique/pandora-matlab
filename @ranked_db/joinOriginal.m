function a_db = joinedOriginal(a_ranked_db, rows)

% joinedOriginal - Joins the distance values to the original db rows with matching row indices.
%
% Usage:
% a_db = joinedOriginal(a_ranked_db, rows)
%
% Description:
%   Takes the parameter columns from orig_db and all tests from crit_db.
%
%   Parameters:
%	a_ranked_db: A ranked_db object.
%	rows: Join only the given rows.
%		
%   Returns:
%	a_db: A params_tests_db object (same type as a_ranked_db.orig_db) containing 
%		the desired rows in ascending order of distance.
%
% See also: tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/21

crit_cols = fieldnames(get(a_ranked_db.crit_db, 'col_idx'));
db_cols = fieldnames(get(a_ranked_db.orig_db, 'col_idx'));
a_db = joinRows(a_ranked_db.orig_db, {db_cols{1:a_ranked_db.orig_db.num_params}, ...
				      crit_cols{1:24}}, ...
		onlyRowsTests(a_ranked_db, rows, ':'), {'Distance', 'RowIndex'});

