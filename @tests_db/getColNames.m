function col_names = getColNames(db, cols)

% getColNames - Gets column names.
%
% Usage:
% col_names = getColNames(db, cols)
%
% Description:
%   Performs a light operation without touching the data matrix.
%
%   Parameters:
%	db: A tests_db object.
%	cols: Columns for which to get names (Optional, default = ':')
%		
%   Returns:
%	col_names: A cell array of strings.
%
% See also: getColNames, tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/05/24

if ~ exist('cols')
  cols = ':';
end

cols = tests2cols(db, cols);

col_names = fieldnames(get(db, 'col_idx'));
col_names = col_names{cols};
