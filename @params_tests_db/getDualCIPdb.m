function a_db = getDualCIPdb(db, depol_tests, hyper_tests, depol_suffix, hyper_suffix)

% getDualCIPdb - Generates a database by merging selected tests of depolarizing and hyperpolarizing cip results.
%
% Usage:
% a_db = getDualCIPdb(db, depol_tests, hyper_tests, depol_suffix, hyper_suffix)
%
% Description:
%
%   Parameters:
%	db: A params_tests_db object.
%		
%   Returns:
%	a_db: A params_tests_db object of organized values.
%
% See also: invarValues, tests_3D_db, corrCoefs, tests_3D_db/plotPair
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/01/13

%# Fold in two according to cip values
cip_fold_db = swapRowsPages(invarParam(db, 'pAcip'));

%# Merge the selected tests from each of the two pages
merged_db = mergePages(cip_fold_db, {hyper_tests, depol_tests}, ...
		       {hyper_suffix, depol_suffix});

%# Get the parameters back (except pAcip)
wo_cip_params = true(1, db.num_params);
wo_cip_params(tests2cols(db, 'pAcip')) = false(1);
joined_db = joinRows(db, wo_cip_params, merged_db, ':');

%# Remove the RowIndex column
wo_index = true(1, dbsize(joined_db, 2));
wo_index(tests2cols(joined_db, 'RowIndex')) = false(1);
a_db = onlyRowsTests(joined_db, ':', wo_index);

%# TODO: give a better name?
a_db = set(a_db, 'id', [ get(db, 'id') ' dual cip' ]);