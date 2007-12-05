function a_db = joinRows(a_db, with_db, props)

% joinRows - Joins the rows of the given db with rows of with_db with matching RowIndex values.
%
% Usage:
% a_db = joinRows(a_db, with_db, props)
%
% Description:
%   Takes the desired columns in with_db with rows having a 
% row index and joins them next to desired columns from the current db. 
% Assumes each row index only appears once in with_db. The created
% db preserves the ordering of with_db.
%
%   Parameters:
%	a_db: A tests_db object.
%	with_db: A tests_db object with a row index column.
%	props: A structure with any optional properties.
%	  indexColName: (Optional) Name of row index column (default='RowIndex').
%		
%   Returns:
%	a_db: A tests_db object.
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

if ~ exist('props', 'var')
  props = struct;
end

data = get(a_db, 'data');
w_data = get(with_db, 'data');

if isfield(props, 'indexColName')
  index_col_name = props.indexColName;
else
  index_col_name = 'RowIndex';
end

vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

join_col = tests2cols(with_db, index_col_name);
joins = w_data(:, join_col);

% TODO: below fails if all row indices are NaN in a row
if any(isnan(joins))
  if verbose
    warning(['NaNs in ' index_col_name ' column. Proceeding with caution.']);
  end

  %# Find all RowIndex columns
  row_index_cols = strmatch('RowIndex', fieldnames(get(with_db, 'col_idx')));

  %# Then look for missing values in other columns
  all_joins = w_data(:, row_index_cols);
  all_non_nans = ~isnan(all_joins);
  for joins_row = 1:size(all_joins, 1)
    tmp_j = all_joins(joins_row, all_non_nans(joins_row, :));
    if isempty(tmp_j)
      joins(joins_row) = NaN;
    else
      joins(joins_row) = tmp_j(1);
    end
  end
end

% TODO: one can use addColumns instead
size_db = dbsize(a_db);
size_wdb = dbsize(with_db);

new_size(1) = size_wdb(1);
new_size(2) = size_db(2) + size_wdb(2); %# Except the page index

new_data = [ data(joins(~isnan(joins)), :), w_data(~isnan(joins), :) ];

%# Get the column names straight
cols_cell1 = fieldnames(get(a_db, 'col_idx'));
cols_cell2 = fieldnames(get(with_db, 'col_idx'));
a_db = set(a_db, 'data', new_data);
a_db = set(a_db, 'col_idx', makeIdx({ cols_cell1{:}, cols_cell2{:} }));
a_db = set(a_db, 'id', [ get(a_db, 'id') ' joined with ' get(with_db, 'id')]);
