function cols = tests2cols(db, tests)

% tests2cols - Find column numbers from a test names/numbers specification.
%
% Usage:
% cols = tests2cols(db, tests)
%
% Description:
%
%   Parameters:
%	db: A tests_db object.
%	tests: Either a single or array of column numbers, or a single
%		test name or a cell array of test names. If ':', all tests.
%		
%   Returns:
%	cols: Array of column indices.
%
% See also: tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/07

col_vals = struct2cell(db.col_idx);

%# Parse tests
cols = [];
if ischar(tests) && strcmp(tests, ':')
  cols = [ col_vals{:} ];
elseif isnumeric(tests)
  cols = tests;
elseif ischar(tests)
  cols = getfield(db.col_idx, tests);
elseif iscell(tests)
  for test=tests
    test = test{1}; %# unwrap the cell
    if ischar(test)
      col = getfield(db.col_idx, test);
    elseif isnumeric(test)
      col = test;
    else
      display(test);
      error(['Test not recognized.' ]);
    end

    cols = [cols, col];
  end
else
  error(['tests can either be '':'', column number or array of numbers,'...
	 ' column name or cell array of names.']);
end
