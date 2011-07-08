function idx = tests2idx(db, dim_num, tests)

% tests2idx - Find dimension indices from a test names/numbers specification.
%
% Usage:
% idx = tests2idx(db, dim_num, tests)
%
% Description:
%
%   Parameters:
%	db: A tests_db object.
%	dim_num: Number between 1-3 to choose dimension: row, column, or page.
%	tests: Either a single or array of column numbers, or a single
%		test name or a cell array of test names. If ':', all
%		tests. For name strings, regular expressions are
%		supported if quoted with slashes (e.g., '/a.*/')
%		
%   Returns:
%	idx: Array of column indices.
%
% Example:
% >> cols = tests2idx(a_db, 2, {'col1', '/col2+/'});
% will return indices of col1 and columns like col2, col22, col22, etc.
%
% See also: tests_db, tests2cols, regexp
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
%dim_name_str = struct('row', 1, 'col', 2, 'page', 3);

if ~ isnumeric(dim_num) || dim_num < 1 || dim_num > 3
  error('dim_num must be within [1,3]');
end

dim_names = {'row', 'col', 'page'};
dim_name = dim_names{dim_num};

%strmatch(dim_name, possible_dim_names, 'exact');
% $$$ try 
% $$$   dim_num = dim_name_str.(dim_name);
% $$$ catch
% $$$   % sanity check
% $$$   %if isempty(dim_num)
% $$$   lasterror
% $$$   names = strcat(fieldnames(dim_name_str)', ', ')';
% $$$   error([ 'dim_name "' dim_name '" not recognized. It can only be one of these: ' ...
% $$$           strcat(names{:}) '.' ] );
% $$$ end


% Parse tests
idx = [];
if ischar(tests) && strcmp(tests, ':')
  idx = 1:dbsize(db, dim_num);
elseif islogical(tests)
  idx = find(tests);
elseif isnumeric(tests) 
  idx = tests;
elseif ischar(tests)
  ind_struct = db.([ dim_name '_idx']);
  % check if regexp first
  if tests(1) == '/'
    idx = findRegExpIdx(tests, fieldnames(ind_struct)');
  else
    idx = getfuzzyfield(ind_struct, tests, NaN, 1);
    if isempty(idx)
      error(['Field ''' tests ''' not found in db']);
    end
  end
elseif iscell(tests)
  tests={tests{:}}; % add by Li Su, change the array to a row vector.
  ind_struct = db.([ dim_name '_idx']);
  all_names = fieldnames(ind_struct);
  for test1=tests
    test = test1{1}; % unwrap the cell
    if ischar(test)
      if test(1) == '/'
        ind = findRegExpIdx(test, all_names');
      else
        ind = getfuzzyfield(ind_struct, test, NaN, 1);
        if isempty(ind)
          error(['Field ''' test ''' not found in db']);
        end
      end
    elseif isnumeric(test)
      ind = test;
    else
      display(test);
      error('Test not recognized.');
    end

    idx = [idx, ind];
  end
else
  error(['tests can either be '':'', column number or array of numbers,'...
	 ' column name or cell array of names.']);
end
