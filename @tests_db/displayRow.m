function s = displayRow(db, row_index)

% displayRow - Displays a row of data with associated column labels.
%
% Usage:
% s = displayRow(db, row_index)
%
% Description:
%
%   Parameters:
%	db: A tests_db object.
%	row_index: Index of row in db.
%		
%   Returns:
%	s: A structure of column name and value pairs.
%
% See also: tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/15

s = cell2struct(num2cell(db.data(row_index, :)), fieldnames(db.col_idx), 2);

