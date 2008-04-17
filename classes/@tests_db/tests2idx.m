function idx = tests2idx(db, dim_name, tests)

% tests2idx - Find dimension indices from a test names/numbers specification.
%
% Usage:
% idx = tests2idx(db, dim_name, tests)
%
% Description:
%
%   Parameters:
%	db: A tests_db object.
%	dim_name: String indicating 'row', 'col', or 'page'
%	tests: Either a single or array of column numbers, or a single
%		test name or a cell array of test names. If ':', all
%		tests. For name strings, regular expressions are
%		supported if quoted with slashes (e.g., '/a.*/')
%		
%   Returns:
%	idx: Array of column indices.
%
% Example:
% >> cols = tests2idx(a_db, 'col', {'col1', '/col2+/'});
% will return indices of col1 and columns like col2, col22, col22, etc.
%
% See also: tests_db, tests2cols
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/07

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% note: page_idx only exists in tests_3D_db
possible_dim_names = {'row', 'col', 'page'};
dim_num = strmatch(dim_name, possible_dim_names, 'exact');

% sanity check
if isempty(dim_num)
  names = strcat(possible_dim_names', ', ')';
  error([ 'dim_name "' dim_name '" not recognized. It can only be one of these: ' ...
          strcat(names{:}) '.' ] );
end

ind_struct = db.([ dim_name '_idx']);

all_names = fieldnames(ind_struct);
if isempty(all_names)
  ind_vals = num2cell(1:dbsize(db, dim_num));
else
  ind_vals = struct2cell(ind_struct);
end

% Parse tests
idx = [];
if ischar(tests) && strcmp(tests, ':')
  idx = [ ind_vals{:} ];
elseif islogical(tests)
  idx = find(tests);
elseif isnumeric(tests) 
  idx = tests;
elseif ischar(tests)
  % check if regexp first
  idx = findRegExpIdx(tests, all_names');
  if isnan(idx)
    idx = getfuzzyfield(ind_struct, tests);
    if isempty(idx)
      error(['Field ''' tests ''' not found in db']);
    end
  end
elseif iscell(tests)
  tests={tests{:}}; % add by Li Su, change the array to a row vector.
  for test1=tests
    test = test1{1}; % unwrap the cell
    if ischar(test)
      ind = findRegExpIdx(test, all_names');
      if isnan(ind)
        ind = getfuzzyfield(ind_struct, test);
        if isempty(ind)
          error(['Field ''' test ''' not found in db']);
        end
      end
    elseif isnumeric(test)
      ind = test;
    else
      display(test);
      error(['Test not recognized.' ]);
    end

    idx = [idx, ind];
  end
else
  error(['tests can either be '':'', column number or array of numbers,'...
	 ' column name or cell array of names.']);
end
