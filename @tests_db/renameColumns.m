function a_db = renameColumns(a_db, test_names, new_names)

% renameColumns - Rename an existing column or columns.
%
% Usage:
% a_db = renameColumns(a_db, test_names, new_names)
%
% Description:
%   This is a cheap operation than modifies meta-data kept in object.
%
% Parameters:
%	a_db: A tests_db object.
%	test_names: A cell array of existing test names.
%	new_names: New names to replace existing ones.
%		
% Returns:
%	a_db: The tests_db object that includes the new columns.
%
% Example:
% % Renaming a single column:
% >> new_db = renameColumns(a_db, 'PulseIni100msSpikeRateISI_D40pA', 'Firing_rate');
% % Renaming multiple columns:
% >> new_db = renameColumns(a_db, {'a', 'b'}, {'c', 'd'});
%
% See also: allocateRows, tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/09/30

%# For vector input, recurse in loop
num_tests = length(test_names);
if iscell(test_names) && num_tests > 1
  if num_tests ~= length(new_names)
    error('Existing and new names should have same number of items to rename columns.');
  end
  for col_num=1:num_tests
    a_db = renameColumns(a_db, test_names{col_num}, new_names{col_num});
  end
  return
end

%# Single column mode
col_idx = a_db.col_idx;
col_idx.(new_names) = col_idx.(test_names);
col_idx = rmfield(col_idx, test_names);

%# Reorder struct
[cols perm] = sort(cell2mat(struct2cell(col_idx)));
a_db.col_idx = orderfields(col_idx, perm);
