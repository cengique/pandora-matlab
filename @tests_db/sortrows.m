function [sorted, idx] = sortrows(db, cols)

% sortrows - Returns a sorted db according to given columns. 
%
% Usage:
% [sorted, idx] = sortrows(db, cols)
%
% Description:
%   For multi-page dbs, sorts only the first page and applies the ordering 
% to all other pages.
%
%   Parameters:
%	db: A tests_db object.
%	cols: Columns to use for sorting.
%		
%   Returns:
%	sorted: The sorted tests_db.
%	idx: The row index permutation vector. 
%
% See also: sortrows, tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/11

if ~ exist('cols')
  cols = ':';
end

data = get(db, 'data');
db_size = size(data);
num_pages = db_size(3);
pages=1:num_pages;

cols = tests2cols(db, cols);
%#idx = repmat(NaN, [db_size(1) 1]);

%# Sort the first page
[a idx] = sortrows(data(:,:,1), cols);

%# Sort each page with the first page idx
for page_num=pages
  data(:, :, page_num) = data(idx, :, page_num);
end

%# Reorder row_idx if it exists
row_names = fieldnames(db.row_idx);
if ~ isempty(row_names)
  row_names = row_names(idx);
end

%# Create a new db (or maybe only set fields so that the object stays the same?)
if num_pages > 1
  sorted = tests_3D_db(data, fieldnames(get(db, 'col_idx')), row_names, ...
		       fieldnames(get(db, 'page_idx')), ...
		       get(db, 'id'), get(db, 'props'));
else
  sorted = tests_db(data, fieldnames(get(db, 'col_idx')), row_names, ...
		    get(db, 'id'), get(db, 'props'));  
end