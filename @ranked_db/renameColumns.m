function a_db = renameColumns(a_db, test_names, new_names)

% renameColumns - Rename an existing column or columns.
%
% Usage:
% a_db = renameColumns(a_db, test_names, new_names)
%
% Description:
%   This method is an overloaded method for ranked_db that keeps consistent
% the column names of the ranked, criterion and original DBs. The other
% DBs are not renamed for the Distance and RowIndex columns.
%
% Parameters:
%	a_db: A ranked_db object.
%	test_names: A cell array of existing test names.
%	new_names: New names to replace existing ones.
%		
% Returns:
%	a_db: The ranked_db object that includes the new columns.
%
% Example: see tests_db/renameColumns
%
% See also: tests_db/renameColumns
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/06/07

a_db.tests_db = renameColumns(a_db.tests_db, test_names, new_names);

%if ~ iscell(test_names) || length(test_names) == 1
%  test_names = { test_names };
%end

[some_test_names, idx] = setdiff(test_names, {'Distance', 'RowIndex'});

if ~isempty(idx)
  a_db.orig_db = ...
      renameColumns(a_db.orig_db, test_names(idx), new_names(idx));
  a_db.crit_db = ...
      renameColumns(a_db.crit_db, test_names(idx), new_names(idx));
end
