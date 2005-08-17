function s = rows2Struct(db, rows, pages)

% rows2Struct - Convert given rows of database to a structure array.
%
% Usage:
% s = rows2Struct(db, rows, pages)
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
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/08/17

if ~ exist('pages')
  pages = 1;
end

if ~ exist('rows')
  rows = ':';
end

%# Make a cell array out of db contents
col_names = fieldnames(db.col_idx);
s = cell2struct(num2cell(db.data(rows, :, pages)), col_names, 2);
