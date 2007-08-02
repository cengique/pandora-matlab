function col_names = getColNames(db, tests)

% getColNames - Gets column names.
%
% Usage:
% col_names = getColNames(db, tests)
%
% Description:
%   Performs a light operation without touching the data matrix.
%
%   Parameters:
%	db: A tests_db object.
%	tests: Columns for which to get names (Optional, default = ':')
%		
%   Returns:
%	col_names: A cell array of strings.
%
% See also: getColNames, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/05/24

if ~ exist('tests')
  tests = ':';
end

cols = tests2cols(db, tests);

col_names = fieldnames(get(db, 'col_idx'));
col_names = {col_names{cols}};
