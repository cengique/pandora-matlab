function crit_db = matchingRow(a_db, row, tests)

% matchingRow - Creates a criterion database for matching the tests of a row.
%
% Usage:
% crit_db = matchingRow(a_db, row, tests)
%
% Description:
%   Calls tests_db/matchingRow after removing parameter columns.
%
%   Parameters:
%	a_db: A params_tests_db object.
%	row: A row index to match.
%	tests: Test name of column indices (see tests2cols).
%		
%   Returns:
%	crit_db: A tests_db with two rows for values and STDs.
%
% See also: tests_db/matchingRow, rankMatching, tests_db, tests2cols
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/03/15

if ~ exist('tests')
  tests = ':';
end

%# Matlab doesn't call subsref from methods @&#&#$^
wo_params_db = ...
    subsref(a_db, substruct('()', {':', ...
				   (a_db.num_params + 1):dbsize(a_db, 2)}));

crit_db = matchingRow(wo_params_db.tests_db, row, tests);