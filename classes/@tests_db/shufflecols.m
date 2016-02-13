function a_db = shufflecols(db, rows, grouped)

% shufflecols - Returns a db with shuffled columns of given rows. 
%
% Usage:
% s = shufflecols(db, rows, grouped)
%
% Description:
%   Can be used for shuffle prediction. Basically, shuffle columns of tests and rerun
% high order analyses. 
%
%   Parameters:
%	db: A tests_db object.
%	rows: Rows to shuffle.
%	grouped: If 1 then apply same shuffling to all rows, 
%		if 0 shuffle each row independently (default=0).
%		
%   Returns:
%	a_db: The shuffled db.
%
% See also: tests_db
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2015/11/19

% Copyright (c) 2015 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('grouped', 'var')
  grouped = 0;
end

rows = tests2rows(db, rows);
num_cols = dbsize(db, 2);
data = get(db, 'data');

if grouped == 1
    data(rows, :, 1) = data(rows, randperm(num_cols)', 1);
else
  for row_num = rows
    data(row_num, :, 1) = data(row_num, randperm(num_cols)', 1);
  end
end

a_db = set(db, 'data', data);
