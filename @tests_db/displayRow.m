function s = displayRow(db, rows, pages)

% displayRow - Displays a row of data with associated column labels.
%
% Usage:
% s = displayRow(db, rows)
%
% Description:
%
%   Parameters:
%	db: A tests_db object.
%	rows: Indices of rows in db.
%	pages: Pages of db.
%		
%   Returns:
%	s: A structure of column name and value pairs.
%
% See also: tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/15

if ~ exist('pages')
  pages = 1;
end

if ~ exist('rows')
  rows = ':';
end

%# Make a cell array out of db contents
col_names = fieldnames(db.col_idx);
if ~ isempty(col_names)
  s = cat(2, col_names, num2cell(db.data(rows, :, pages))');
else
  s = num2cell(db.data(rows, :, pages));
end

%# Add row names
row_names = fieldnames(db.row_idx);
if ~ isempty(row_names)
  s = cat(1, {'', row_names{:}}, s);
end