function a_db = renameColumns(a_db, old_names, new_names)

% renameColumns - Rename one or more existing columns.
%
% Usage:
% a_db = renameColumns(a_db, old_names, new_names)
%
% Parameters:
%   a_db: A tests_db object.
%   old_names: A cell array of existing names, array of numerical indices, or a regular
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
% % Renaming an unnamed column:
% >> new_db = renameColumns(a_db, 1, 'Firing_rate');
% % Renaming using regular expressions: add suffix to all columns
% >> new_db = renameColumns(a_db, '/(.*)/', '$1_old');
% % Renaming multiple columns:
% >> new_db = renameColumns(a_db, {'a', 'b'}, {'c', 'd'});
%
% Description:
%   This is a cheap operation than modifies meta-data kept in object. For
% the regular expression renaming, the old_names and new_names
% parameters are passed to the regexprep command after removing the
% delimiting slashes (//). At least one grouping construct ('()') must be
% used in the search pattern such that it can be used in the replacement
% pattern (e.g., '$1'). See example above. This function uses the generic
% renameIdx that can work on row, column, or page indices.
%
% See also: renameIdx, regexprep, allocateRows, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2017/06/09

% Copyright (c) 2017 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

a_db.col_idx = renameIdx(a_db.col_idx, old_names, new_names);
