function t_hists = testsHists(a_db)

% testsHists - Calculates histograms for all tests and returns them in a cell array.
%
% Usage:
% t_hists = testsHists(a_db)
%
% Description:
%   Skips the 'ItemIndex' test.
%
%   Parameters:
%	a_db: A tests_db object.
%		
%   Returns:
%	t_hists: An array of histograms for each test in a_db.
%
% See also: params_tests_profile
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/17

tests = fieldnames(get(a_db, 'col_idx'));
itemIndices = strmatch('ItemIndex', tests);

%# Strip out the RowIndex and ItemIndex columns from criterion db
tests = setdiff(tests, {'RowIndex', tests{itemIndices}});

%# Preserve original column order (parameters at the beginning)
cols = sort(tests2cols(a_db, tests));

%# Filter relevant columns
reduced_db = onlyRowsTests(a_db, ':', cols);

num_params = reduced_db.num_params;

reduced_db = onlyRowsTests(reduced_db, ':', ...
			   (num_params + 1):(dbsize(reduced_db, 2)));

t_hists = testsHists(reduced_db.tests_db);
