function [sorted_db, idx] = sortrows(db, cols)

% sortrows - Returns a sorted_db according to given columns. 
%
% Usage:
% [sorted_db, idx] = sortrows(db, cols)
%
% Description:
%   WARNING: For multi-page dbs, sorts only the first page and applies the ordering 
% to all other pages which may produce wrong results for some applications.
%
%   Parameters:
%	db: A tests_db object.
%	cols: Columns to use for sorting.
%		
%   Returns:
%	sorted_db: The sorted tests_db.
%	idx: The row index permutation vector, such that sorted_db = db(idx, :). 
%
% See also: sortrows, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/11

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('cols')
  cols = ':';
end

db_size = size(db.data);
if length(db_size) > 2
  num_pages = db_size(3);
else
  num_pages = 1;
end
pages=1:num_pages;

cols = tests2cols(db, cols);
%idx = repmat(NaN, [db_size(1) 1]);

if num_pages > 1
  % Sort the first page
  [db.data(:,:,1) idx] = sortrows(db.data(:,:,1), cols);


  % Sort each page with the first page idx
  for page_num=2:num_pages
    db.data(:, :, page_num) = db.data(idx, :, page_num);
  end
else
  % Sort all
  [db.data idx] = sortrows(db.data, cols);
end

% Reorder row_idx if it exists
row_names = fieldnames(db.row_idx);
if ~ isempty(row_names)
  row_names = row_names(idx);
end

sorted_db = db;
sorted_db = set(sorted_db, 'row_idx', makeIdx(row_names));

% Create a new db (or maybe only set fields so that the object stays the same?)
%if isa(db, 'tests_3D_db')
%  sorted = tests_3D_db(data, fieldnames(get(db, 'col_idx')), row_names, ...
%		       fieldnames(get(db, 'page_idx')), ...
%		       get(db, 'id'), get(db, 'props'));
%else
%  sorted = tests_db(data, fieldnames(get(db, 'col_idx')), row_names, ...
%		    get(db, 'id'), get(db, 'props'));  
%end