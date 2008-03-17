function a_db = joinRows(a_db, w_db, props)

% joinRows - Joins a_db rows with w_db rows having matching RowIndex values.
%
% Usage:
% a_db = joinRows(a_db, w_db, props)
%
% Description:
%   Concatenates columns of rows matching the join condition from the two
% databases. Each row index must appear only once in w_db. The created db
% preserves the ordering of w_db. See the multipleIndices option if there
% are several redundant index columns. Multiple pages in w_db are accepted
% (see keepNaNs option).
%   This function is the equivalent of a "right outer join" command in SQL, w_db
% being the database table on the right.
%
%   Parameters:
%	a_db: A tests_db object.
%	w_db: A tests_db object with a row index column.
%	props: A structure with any optional properties.
%	  indexColName: (Optional) Name of row index column
%	  	(default='RowIndex').
%	  keepNaNs: If 1, substitute NaN values for NaN indices. 
%		    (default=1, for multi-page DBs; 0, otherwise).
%	  multipleIndices: If 1, search for substitute RowIndex* columns for
%	  	indices with NaN values. It will fail if all indices are NaNs.
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

vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

if ~ exist('props', 'var')
  props = struct;
end

if isfield(props, 'indexColName')
  index_col_name = props.indexColName;
else
  index_col_name = 'RowIndex';
end

data = get(a_db, 'data');

% remove the index column from w_db
wd_db = delColumns(w_db, index_col_name);
w_data = get(wd_db, 'data');

% get final size from w_db
num_pages = dbsize(w_db, 3);

% calculate size and initialize if we're keeping NaNs
keep_NaNs = false;
if num_pages > 1 || (isfield(props, 'keepNaNs') && props.keepNaNs == 1)
  keep_NaNs = true;
  size_db = dbsize(a_db);
  size_wdb = dbsize(w_db);

  % initialize with NaNs (except page index)
  new_data = ...
      repmat(NaN, [size_wdb(1), ...
                   size_db(2) + size_wdb(2) - 1, num_pages]);
end % keepNaNs

% for each page
for page_num = 1:num_pages

  joins = get(onlyRowsTests(w_db, ':', index_col_name, page_num), 'data');

  % below fails if all row indices are NaN in a row
  if isfield(props, 'multipleIndices') && any(isnan(joins))
    if verbose
      warning(['NaNs in ' index_col_name ' column. Proceeding with caution.']);
    end

    % Find all RowIndex columns
    row_index_cols = strmatch('RowIndex', fieldnames(get(w_db, 'col_idx')));

    % Then look for missing values in other columns
    all_joins = get(onlyRowsTests(w_db, ':', row_index_cols, page_num), 'data');
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

  non_nan_joins = ~isnan(joins);
  if keep_NaNs
    % keep NaNs instead of values from db
    new_data(non_nan_joins, :, page_num) = ...
        [ data(joins(non_nan_joins), :), w_data(non_nan_joins, :, page_num) ];
  else
    % TODO: could use addColumns in the simple case?
    %a_db = addColumns(onlyRowsTests(a_db, joins(non_nan_joins), ':'), ...
    %                  onlyRowsTests(w_db, non_nan_joins, ':'));
    % assume only one page
    new_data = ...
        [ data(joins(non_nan_joins), :), w_data(non_nan_joins, :) ];
  end

end % page_num

% Get the column names straight
cols_cell1 = fieldnames(get(a_db, 'col_idx'));
cols_cell2 = fieldnames(get(wd_db, 'col_idx'));
a_db = set(a_db, 'data', new_data);
a_db = set(a_db, 'col_idx', makeIdx({ cols_cell1{:}, cols_cell2{:} }));
a_db = set(a_db, 'id', [ get(a_db, 'id') ' joined with ' get(w_db, 'id')]);
