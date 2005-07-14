function a_db = mergeMultipleCIPsInOne(db, names_tests_cell, index_col_name)

% mergeMultipleCIPsInOne - Merges multiple rows with different CIP data into one, generating a database of one row per neuron.
%
% Usage:
% a_db = mergeMultipleCIPsInOne(db, names_tests_cell, index_col_name)
%
% Description:
%   It calls invarParam to separate db into pages with different CIP level data.
% Then uses the names_tests_cell to choose tests from each page to be merged into the 
% final database row. The tests will be suffixed with the field name so that 
% they can be distinguished. RowIndex columns
% will be automatically included, and one of them can be chosen with index_col_name
% that has values for all cells. The suffixed for needs to be used to 
% choose index_col_name, such as 'RowIndex_H100pA', assuming 'H100pA' was the field
% name in names_tests_cell that corresponds to page -100 pA.
%
%   Parameters:
%	db: A params_tests_db object.
%	names_tests_cell: A cell array alternating suffix names and test column vectors.
%		The order of names correspond to each unique CIP level in db, 
%		with increasing order.
%	index_col_name: (Optional) Name of row index column 
%		(default is 'RowIndex' suffixed with the first field name).
%		
%   Returns:
%	a_db: A params_tests_db object of organized values.
%
%   Example:
%	>> control_phys_sdb = 
%             mergeMultipleCIPsInOne(control_phys_db, 
%			             struct('_H100pA', [1:10], '_D100pA', [1:10 16:18]), 
%				     'RowIndex_H100pA')
%
% See also: invarValues, tests_3D_db, corrCoefs, tests_3D_db/plotVarBox
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/01/13

%# TODO: automatically derive the correct RowIndices, by filling in missing values?
%#	 do this in invarParam??

%# Fold into multiple pages, according to cip values
cip_fold_db = swapRowsPages(invarParam(sortrows(db, 'pAcip'), 'pAcip'));

num_pages = dbsize(cip_fold_db, 3);

%# Read names and tests into separate cell arrays
page_suffixes = {names_tests_cell{1:2:end}};
tests_cell = {names_tests_cell{2:2:end}};

if length(page_suffixes) ~= num_pages
  error(['Number of items in names_tests_cell does not match with ' num2str(num_pages) ...
	 ' unique CIP valus in the database.']);
end

%# Merge the selected tests from each page
merged_db = mergePages(cip_fold_db, tests_cell, page_suffixes);

%# Get the parameters back (except pAcip)
wo_cip_params = true(1, db.num_params);
wo_cip_params(tests2cols(db, 'pAcip')) = false(1);
joined_db = joinRows(db, wo_cip_params, merged_db, ':', index_col_name);

%# Remove the RowIndex columns
test_names = fieldnames(get(joined_db, 'col_idx'));
found_indices = strmatch('RowIndex', test_names);
wo_index = true(1, dbsize(joined_db, 2));
wo_index(found_indices) = false(1);
a_db = onlyRowsTests(joined_db, ':', wo_index);

%# TODO: give a better name?
a_db = set(a_db, 'id', [ get(db, 'id') ' mult CIP' ]);