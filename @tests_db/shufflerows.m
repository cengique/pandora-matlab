function a_db = shufflerows(db, tests, grouped)

% shufflerows - Returns a db with rows of given test columns are shuffled. 
%
% Usage:
% s = shufflerows(db, dim)
%
% Description:
%   Can be used for shuffle prediction. Basically, shuffle rows of tests and rerun
% high order analyses. 
%
%   Parameters:
%	db: A tests_db object.
%	tests: Tests to shuffle.
%	grouped: If 1 then shuffle tests all together, 
%		if 0 shuffle each test separately.
%		
%   Returns:
%	a_db: The shuffled db.
%
% See also: tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/11/10

if ~ exist('grouped')
  grouped = 0;
end

cols = tests2cols(db, tests);
num_rows = size(db, 1);
data = get(db, 'data');

if grouped == 1
    data(:, cols, 1) = data(randperm(num_rows)', cols, 1);
else
  for col_num = cols
    data(:, col_num, 1) = data(randperm(num_rows)', col_num, 1);
  end
end

a_db = set(db, 'data', data);