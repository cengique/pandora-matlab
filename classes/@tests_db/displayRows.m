function s = displayRows(db, rows, pages)

% displayRows - Displays rows of data with associated column labels.
%
% Usage:
% s = displayRows(db, rows, pages)
%
% Description:
%
%   Parameters:
%	db: A tests_db object.
%	rows: Indices of rows in db.
%	pages: Pages of db.
%		
%   Returns:
%	s: A cell array of trasposed database contents, prefixed with 
%	   column names on each row. Meant to be displayed on the screen.
%
% See also: tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/15

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

% Modified: CG 2005/08/17 - Renamed from displayRow

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