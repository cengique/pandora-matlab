function row_indices = getParamRowIndices(a_db, rows, to_db)

% getParamRowIndices - Returns indices of rows with matching parameter values from rows of this db.
%
% Usage:
% row_indices = getParamRowIndices(a_db, rows, to_db)
%
% Description:
%
%   Parameters:
%	a_db: A params_tests_db object.
%	rows: rows to find indices for.
%	to_db: Where to find the matching rows.
%
%   Returns:
%	row_indices: Array of row indices.
%
% See also: makeModifiedParamDB, scanParamAllRows, scaleParamsOneRow, makeGenesisParFile
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/01/14

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

if ischar(rows) && strcmp(rows, ':')
  rows = 1:dbsize(a_db, 1);
end

data = get(a_db, 'data');
row_indices = [];
for row_num=rows
  row = data(row_num, :);
  lrows = true(dbsize(to_db, 1), 1);
  for param_num=1:a_db.num_params
    col_db = onlyRowsTests(to_db, ':', param_num);
    lrows = lrows & (col_db >= (row(param_num) - eps) & col_db <= (row(param_num) + eps));
  end
  found_num = find(lrows);
  if length(found_num) > 1 
    warning(['Found multiple matches for row ' num2str(row_num) '.' ]);
    found_num = NaN;
  elseif length(found_num) == 0
    warning(['No match found for row ' num2str(row_num) '.' ]);
    row
    found_num = NaN;
  end
  row_indices = [row_indices, found_num];  
end
