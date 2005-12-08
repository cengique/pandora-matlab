function t_hists = testsHists(a_db, num_bins)

% testsHists - Calculates histograms for all tests and returns them in a cell array.
%
% Usage:
% t_hists = testsHists(a_db, num_bins)
%
% Description:
%   Skips the 'ItemIndex' test.
%
%   Parameters:
%	a_db: A tests_db object.
%	num_bins: Number of histogram bins (Optional, default=100), or
%		  vector of histogram bin centers.
%		
%   Returns:
%	t_hists: An array of histograms for each test in a_db.
%
% See also: params_tests_profile
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/17

num_dbs = length(a_db);
if num_dbs > 1
  [reduced_db(1:num_dbs)] = deal(params_tests_db);
  for db_num=1:num_dbs
    reduced_db(db_num) = reduce_db(a_db(db_num));
  end
  reduced_tests_db = subsref(reduced_db, substruct('.', 'tests_db'));
else
  reduced_tests_db = reduced_db.tests_db;
end

if exist('num_bins')
  hist_pars = {reduced_tests_db, num_bins};
else
  hist_pars = {reduced_tests_db};
end

t_hists = testsHists(hist_pars{:});

end				%# of function

function reduced_db = reduce_db(a_db)
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
end

