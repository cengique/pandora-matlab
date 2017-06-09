function new_idx = renameIdx(old_idx, old_names, new_names)

% renameIdx - Rename one or more items in a database dimension (rows, columns, etc).
%
% Usage:
% new_idx = renameIdx(old_idx, old_names, new_names)
%
% Parameters:
%   old_idx: An indexing structure (a_db.col_idx for columns, etc).
%   old_names: A cell array of existing names, array of numerical indices, or a regular
%   		expression denoted between slashes (e.g., '/(.*)/').
%   new_names: New names to replace existing ones OR regular expression
%   		replace string (no slashes, e.g, '$1_test'). See regexprep command.
%		
% Returns:
%   a_db: The tests_db object that includes the new names.
%
% Example:
% % Renaming a single column:
% >> a_db.col_idx = renameIdx(a_db.col_idx, 'PulseIni100msSpikeRateISI_D40pA', 'Firing_rate');
% % Renaming an unnamed column:
% >> a_db.col_idx = renameIdx(a_db.col_idx, 1, 'Firing_rate');
% % Renaming using regular expressions: add a suffix to all columns
% >> a_db.col_idx = renameIdx(a_db.col_idx, '/(.*)/', '$1_old');
% % Renaming multiple columns:
% >> a_db.col_idx = renameIdx(a_db.col_idx, {'a', 'b'}, {'c', 'd'});
% >> a_db.col_idx = renameIdx(a_db.col_idx, [1, 2], {'c', 'd'});
%
% Description:
%   Prefer the convenience methods in tests_db (renameColumns, renameRows) and
% tests_3D_db (renamePages). This is a cheap operation than modifies
% meta-data kept in object. For the regular expression renaming, the
% old_names and new_names parameters are passed to the regexprep command
% after removing the delimiting slashes (//). At least one grouping
% construct ('()') must be used in the search pattern such that it can be
% used in the replacement pattern (e.g., '$1'). See example above.
%
% See also: tests_db/renameColumns, tests_db/renameRows,
% 	    tests_3D_db/renamePages, regexprep, allocateRows
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2017/06/09

% Copyright (c) 2017 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% For vector input, recurse in loop
num_tests = length(old_names);
if ( iscell(old_names) || isnumeric(old_names) ) && num_tests > 1
  if num_tests ~= length(new_names)
    error('Existing and new names should have same number of items to rename items.');
  end
  new_idx = old_idx;
  for col_num=1:num_tests
    new_idx = renameIdx(new_idx, old_names(col_num), new_names(col_num));
  end
  return
elseif iscell(old_names) || iscell(new_names)
  % only one name, then
  if iscell(old_names)
    old_names = old_names{1}; 
  end
  if iscell(new_names)
    new_names = new_names{1};
  end
elseif ~ischar(old_names) && ~isnumeric(old_names)
  error(['Inputs for old_names and new_names must be single strings, ' ...
         'single numerical indices, or ' ...
         'multiple strings in a cell array.']);
end

% Regular expressions?
all_names = fieldnames(old_idx);  
if old_names(1) == '/' && old_names(end) == '/'
  % remove the slashes
  old_names = old_names(2:(end-1));
  % apply to all item names
  all_new_names = regexprep(all_names, old_names, new_names);
  % recurse to use the new names as replacement (not changed items
  % would be skipped
  new_idx = renameIdx(old_idx, all_names, all_new_names);
  return
end

% Single item mode
if strcmp(new_names, old_names) 
  new_idx = old_idx;
  return;                               % nothing to do
end

new_idx = old_idx;

% use numeric index directly
if isnumeric(old_names) 
  new_idx.(new_names) = old_names;
  
  % convert back to name if it exists, so we can delete it
  if ~isempty(old_idx) && length(all_names) >= old_names    
    old_names = all_names{old_names};
  end
else
  % otherwise lookup alphanumerically
  new_idx.(new_names) = new_idx.(old_names);
end

% delete old name
if isfield(new_idx, old_names) && ~strcmp(new_names, old_names)
  new_idx = rmfield(new_idx, old_names);
end

% Reorder struct
[cols perm] = sort(cell2mat(struct2cell(new_idx)));
new_idx = orderfields(new_idx, perm);
