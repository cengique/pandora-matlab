function failed = joinRowsUT

% joinRowsUT - Unit test for tests_db/joinRows
%
% Usage:
% failed = joinRows
%
% Description:
%
% Parameters:
%		
% Returns:
%   failed: Boolean.
%
% See also: 
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/16

a_db = tests_db([ (1:3)'], { 'Control' }, {}, 'test joinRows');

order = [2; 1; 3];
b_db = tests_db(order, {'RowIndex'}, {}, 'index joinRows');

j_db = joinRows(a_db, b_db);

failed = ~(j_db(:, 'Control') == order);

if failed
  disp('Failed test!');
else
  disp('Passed test!');
end