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

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

if ~ exist('tests')
  tests = ':';
end

cols = tests2cols(db, tests);

col_names = fieldnames(get(db, 'col_idx'));
col_names = {col_names{cols}};
