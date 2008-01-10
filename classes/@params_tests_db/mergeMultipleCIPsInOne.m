function cip_fold_db = mergeMultipleCIPsInOne(db, names_tests_cell, ...
                                              index_col_name, props)

% mergeMultipleCIPsInOne - Merges multiple rows with different CIP data into one, generating a database of one row per neuron.
%
% Usage:
% a_db = mergeMultipleCIPsInOne(db, names_tests_cell, index_col_name, props)
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
%	props: A structure with any optional properties.
%	  cipLevels: In case db is missing some levels, provides a list of cip levels that
%    		correspond to names_tests_cell db. Missing levels are replaced with NaN values.
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
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/01/13

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

% Fold into multiple pages, according to cip values
cip_fold_db = swapRowsPages(invarParam(db, 'pAcip'));

if isfield(props, 'cipLevels')
  % align given cip levels
  % use mean as means to remove NaNs ;)
  db_cip_levels = ...
      squeeze(get(mean(onlyRowsTests(cip_fold_db, ':', 'pAcip', ':'), 1), 'data'));
  
  % match one by one
  num_cip_levels = length(props.cipLevels);
  new_cip_fold_data = ...
      repmat(NaN, [dbsize(cip_fold_db, 1), dbsize(cip_fold_db, 2), num_cip_levels]);
  for cip_level = 1:num_cip_levels
    db_page = find(props.cipLevels(cip_level) == db_cip_levels);
    if ~ isempty(db_page)
      new_cip_fold_data(:, :, cip_level) = ...
          cip_fold_db.data(:, :, db_page);
    end
  end
  cip_fold_db = set(cip_fold_db, 'data', new_cip_fold_data);
end

% Read names and tests into separate cell arrays
page_suffixes = {names_tests_cell{1:2:end}};
tests_cell = {names_tests_cell{2:2:end}};

%end
% Rewrite and convert from column numbers to test names for using in cip_fold_db
orig_test_names = fieldnames(get(db, 'col_idx'));
for page_num = 1:length(tests_cell)
  tests_cell{page_num} = { orig_test_names{tests2cols(db, tests_cell{page_num})} };
end

num_pages = dbsize(cip_fold_db, 3);
if length(page_suffixes) ~= num_pages
  error(['Number of items in names_tests_cell does not match with ' ...
	 num2str(num_pages) ' unique CIP values in the database.']);
end

% Merge the selected tests from each page
cip_fold_db = mergePages(cip_fold_db, tests_cell, page_suffixes);

% Get the parameters back (except pAcip)
wo_cip_params = true(1, db.num_params);
wo_cip_params(tests2cols(db, 'pAcip')) = false(1);
cip_fold_db = ...
    joinRows(onlyRowsTests(db, ':', wo_cip_params), cip_fold_db, ...
             struct('indexColName', index_col_name));

% Remove the RowIndex columns
test_names = fieldnames(get(cip_fold_db, 'col_idx'));
found_indices = strmatch('RowIndex', test_names);
wo_index = true(1, dbsize(cip_fold_db, 2));
wo_index(found_indices) = false(1);
cip_fold_db = onlyRowsTests(cip_fold_db, ':', wo_index);

% TODO: give a better name?
cip_fold_db = set(cip_fold_db, 'id', [ get(db, 'id') ' mult CIP' ]);
