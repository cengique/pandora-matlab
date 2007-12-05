function a_db = joinOriginal(a_ranked_db, rows)

% joinOriginal - Joins the distance values to the original db rows with matching row indices.
%
% Usage:
% a_db = joinOriginal(a_ranked_db, rows)
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
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/21

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~exist('rows')
  rows = ':';
end

crit_cols = fieldnames(get(a_ranked_db.crit_db, 'col_idx'));
%# Remove the RowIndex and ItemIndex columns, if exists
all_test_cols(1:length(crit_cols)) = true(1);
if isa(a_ranked_db.crit_db, 'params_tests_db')
  all_test_cols(1:get(a_ranked_db.crit_db, 'num_params')) = false;
end
if any(ismember(crit_cols, 'RowIndex'))
  all_test_cols(tests2cols(a_ranked_db.crit_db, 'RowIndex')) = false(1);
end
if any(ismember(crit_cols, 'NeuronId'))
  all_test_cols(tests2cols(a_ranked_db.crit_db, 'NeuronId')) = false(1);
end
%#if any(ismember(crit_cols, 'ItemIndex'))
%#  all_test_cols(tests2cols(a_ranked_db.crit_db, 'ItemIndex')) = false(1);
%#end
crit_cols = {crit_cols{all_test_cols}};

db_cols = fieldnames(get(a_ranked_db.orig_db, 'col_idx'));
a_db = joinRows(onlyRowsTests(a_ranked_db.orig_db, ':', {db_cols{1:a_ranked_db.orig_db.num_params}, ...
                    crit_cols{:}}), ...
		onlyRowsTests(a_ranked_db, rows, {'Distance', 'RowIndex'}));

