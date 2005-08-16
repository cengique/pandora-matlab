function crit_db = matchingRow(a_db, row, props)

% matchingRow - Creates a criterion database for matching the tests of a row.
%
% Usage:
% crit_db = matchingRow(a_db, row, props)
%
% Description:
%   Calls tests_db/matchingRow after removing parameter columns.
%
%   Parameters:
%	a_db: A params_tests_db object.
%	row: A row index to match.
%	props: A structure with any optional properties.
%		std_db: Take the standard deviation from this db instead.
%		
%   Returns:
%	crit_db: A tests_db with two rows for values and STDs.
%
% See also: tests_db/matchingRow, rankMatching, tests_db, tests2cols
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/03/15

%# Matlab doesn't call subsref from methods @&#&#$^
wo_params_db = ...
    subsref(a_db, substruct('()', {':', ...
				   (a_db.num_params + 1):dbsize(a_db, 2)}));

%# Check for std_db
if isfield(props, 'std_db')
  props.std_db = onlyRowsTests(props.std_db, ':', ...
			       (props.std_db.num_params + 1):dbsize(props.std_db, 2));
end


crit_db = matchingRow(wo_params_db.tests_db, row, props);