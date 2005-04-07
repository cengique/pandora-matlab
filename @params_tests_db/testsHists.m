function t_hists = testsHists(a_db)

% testsHists - Calculates histograms for all tests and returns in a 
%		cell array.
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
num_tests = dbsize(reduced_db, 2) - num_params;

[t_hists(1:num_tests)] = deal(histogram_db);
for test_num=1:num_tests
  t_hists(test_num) = histogram(reduced_db, num_params + test_num);
end
