function a_pm = plotTestsHistsMatrix(a_db)

% plotTestsHistsMatrix - Create a matrix plot of test histograms.
%
% Usage:
% a_pm = plotTestsHistsMatrix(a_db)
%
% Description:
%   Skips the 'ItemIndex' test.
%
%   Parameters:
%	a_db: A params_tests_db object.
%		
%   Returns:
%	a_pm: A plot_stack with the plots organized in matrix form
%
% See also: params_tests_profile, plotVar
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/17

num_params = a_db.num_params;
num_tests = dbsize(a_db, 2) - num_params - 1; %# Except the item indices

tests = fieldnames(get(a_db, 'col_idx'));
itemIndices = strmatch('ItemIndex', tests);

%# Strip out the RowIndex and ItemIndex columns from criterion db
tests = setdiff(tests, {'RowIndex', tests{itemIndices}});

%# Preserve original column order (parameters at the beginning)
cols = sort(tests2cols(a_db, tests));

%# Filter relevant columns
reduced_db = onlyRowsTests(a_db, ':', cols)

a_pm = matrixPlots(plot_abstract(testsHists(reduced_db), 'bar', ...
				 struct('rotateXLabel', 20)), ...
		   {}, ['Measure histograms for ' get(a_db, 'id')]);

