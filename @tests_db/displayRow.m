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
s = cell2struct(num2cell(db.data(rows, :, pages)), fieldnames(db.col_idx), 2);

