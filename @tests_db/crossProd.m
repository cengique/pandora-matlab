function cross_db = crossProd(a_db, b_db)

% crossProd - Create a DB by taking the cross product of two database row sets.
%
% Usage:
% cross_db = crossProd(a_db, b_db)
%
% Description:
%   This is not a vector cross product operation. Each row of the two DBs are matched 
% and added as a new row to a DB. The end is a DB with all combinations 
% of rows from both DBs. The final DB contains columns of both DBs.
%
%   Parameters:
%	a_db, b_db: A tests_db object.
%		
%   Returns:
%	cross_db: The tests_db object with all combinations of rows.
%
% See also: allocateRows, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/10/11

a_size = dbsize(a_db);
b_size = dbsize(b_db);

a_expand_vector = (1:a_size(1));
a_expand_vector = a_expand_vector(ones(1, b_size(1)), :);
a_expand_vector = reshape(a_expand_vector, 1, prod(size(a_expand_vector)));


b_expand_vector = (1:b_size(1))' * ones(1, a_size(1));
b_expand_vector = reshape(b_expand_vector, 1, prod(size(b_expand_vector)));

cross_db = addColumns(onlyRowsTests(a_db, a_expand_vector, ':'), ...
		      onlyRowsTests(b_db, b_expand_vector, ':'));