function obj = onlyRowsTests(obj, rows, tests)

% onlyRowsTests - Returns a tests_db that only contains the desired 
%		tests and rows.
%
% Usage:
% obj = onlyRowsTests(obj, rows, tests)
%
% Description:
% Selects the given test columns and rows and returns in a new tests_db object.
%
%   Parameters:
%	obj: A tests_db object.
%	rows: A logical or index vector of rows. If ':', all rows.
%	tests: Cell array of test names or column indices. If ':', all tests.
%		
%   Returns:
%	obj: The new tests_db object.
%
% See also: subsref, tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/17

%# Setup lookup tables
col_names = fieldnames(obj.col_idx);
col_vals = struct2cell(obj.col_idx);

%# Parse tests
cols = [];
if ischar(tests) && strcmp(tests, ':')
  cols = [ col_vals{:} ];
elseif isnumeric(tests)
  cols = tests;
elseif ischar(tests)
  cols = getfield(obj.col_idx, tests);
elseif iscell(tests)
  for test=tests
    test = test{1}; %# unwrap the cell
    if ischar(test)
      col = getfield(obj.col_idx, test);
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

%# Handle rows
if strcmp(rows, ':')
  obj.data = obj.data(:, cols);
else
  obj.data = obj.data(rows, cols);
end

%# Convert and get col_idx
numsCell = col_names(cols);
[only_names{1:length(cols)}] = deal(numsCell{:});
obj.col_idx = makeColIdx(only_names);

