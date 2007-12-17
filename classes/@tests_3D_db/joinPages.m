function a_db = joinPages(db, tests, with_db, w_tests)

% joinPages - Joins the rows of the given db to the with_db rows matching with the PageIndex
% 	column.
%
% Usage:
% a_db = joinPages(db, tests, with_db, w_tests)
%
% Description:
%   Replicates the desired columns in the with_db with rows having a 
% page index and joins them next to desired columns from the current 3D_db. Flattens 
% the resulting 3D_db to become a 2D db. Assumes each page index only 
% appears once in with_db.
%
%   Parameters:
%	db: A tests_3D_db object.
%	with_db: A tests_db object with a PageIndex column.
%		
%   Returns:
%	a_db: A tests_db object.
%
% See also: tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/15

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

data = get(db, 'data');
w_data = get(with_db, 'data');
page_col = tests2cols(with_db, 'PageIndex');
pages = w_data(:, page_col);
size_db = dbsize(db);
size_wdb = dbsize(with_db);

cols = tests2cols(db, tests);
w_cols = tests2cols(with_db, w_tests);
%log_cols = true(1, size(with_db, 2));
%log_cols(page_col) = false(1);

page_size = size_db(1);

new_size(1) = page_size * size_wdb(1);
new_size(2) = length(cols) + length(w_cols); % Except the page index
new_data = repmat(NaN, new_size);

ones_vector = ones(page_size, 1);

% Do for each row in with_db
for new_page_num=1:size_wdb(1)
  % Concat the data with replicated rows
  new_data(((new_page_num - 1) * page_size + 1):(new_page_num * page_size), :) = ...
      [ data(:, cols, pages(new_page_num)), ...
       ones_vector * w_data(new_page_num, w_cols) ];
end

% Get the column names straight
cols_cell1 = fieldnames(get(db, 'col_idx'));
cols_cell2 = fieldnames(get(with_db, 'col_idx'));
cols_cell1
cols_cell2
cols
w_cols
cols_cell1{cols}
cols_cell2{w_cols}
a_db = tests_db(new_data, ...
		{ cols_cell1{cols}, cols_cell2{w_cols} }, ...
		fieldnames(get(db, 'row_idx')), ...
		[ get(db, 'id') ' joined with ' get(with_db, 'id')], db.props);
