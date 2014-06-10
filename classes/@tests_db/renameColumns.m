function a_db = renameColumns(a_db, test_names, new_names)

% renameColumns - Rename one or more existing columns.
%
% Usage:
% a_db = renameColumns(a_db, test_names, new_names)
%
% Parameters:
%   a_db: A tests_db object.
%   test_names: A cell array of existing test names OR a regular
%   		expression denoted between slashes (e.g., '/(.*)/').
%   new_names: New names to replace existing ones OR regular expression
%   		replace string (no slashes, e.g, '$1_test'). See regexprep command.
%		
% Returns:
%   a_db: The tests_db object that includes the new columns.
%
% Example:
% % Renaming a single column:
% >> new_db = renameColumns(a_db, 'PulseIni100msSpikeRateISI_D40pA', 'Firing_rate');
% % Renaming using regular expressions: add suffix to all columns
% >> new_db = renameColumns(a_db, '/(.*)/', '$1_old');
% % Renaming multiple columns:
% >> new_db = renameColumns(a_db, {'a', 'b'}, {'c', 'd'});
%
% Description:

%   This is a cheap operation than modifies meta-data kept in object. For
% the regular expression renaming, the test_names and new_names
% parameters are passed to the regexprep command after removing the
% delimiting slashes (//). At least one grouping construct ('()') must be
% used in the search pattern such that it can be used in the replacement
% pattern (e.g., '$1'). See example above.
%
% See also: regexprep, allocateRows, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/09/30

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% For vector input, recurse in loop
num_tests = length(test_names);
if iscell(test_names) && num_tests > 1
  if num_tests ~= length(new_names)
    error('Existing and new names should have same number of items to rename columns.');
  end
  for col_num=1:num_tests
    a_db = renameColumns(a_db, test_names{col_num}, new_names{col_num});
  end
  return
elseif iscell(test_names)
  % only one name, then
  test_names = test_names{1}; new_names = new_names{1};
elseif ~ischar(test_names)
  error(['Inputs for test_names and new_names must be single strings or ' ...
         'multiple strings in a cell array.']);
end

% Regular expressions?
if test_names(1) == '/' && test_names(end) == '/'
  % remove the slashes
  test_names = test_names(2:(end-1));
  % apply to all column names
  all_names = getColNames(a_db);  
  all_new_names = regexprep(all_names, test_names, new_names);
  % recurse to use the new names as replacement (not changed columns
  % would be skipped
  a_db = renameColumns(a_db, all_names, all_new_names);
  return
end

% Single column mode
if strcmp(new_names, test_names)
  return;                               % nothing to do
end

col_idx = a_db.col_idx;
col_idx.(new_names) = col_idx.(test_names);
col_idx = rmfield(col_idx, test_names);

% Reorder struct
[cols perm] = sort(cell2mat(struct2cell(col_idx)));
a_db.col_idx = orderfields(col_idx, perm);
