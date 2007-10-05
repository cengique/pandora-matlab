function crit_db = matchingRow(db, row, props)

% matchingRow - Creates a criterion database for matching the tests of a row.
%
% Usage:
% crit_db = matchingRow(db, row, props)
%
% Description:
%   Copies selected test values from row as the first row into the criterion
% db. Adds a second row for the STD of each column in the db.  Calculates the
% covariance for using the Mahalonobis distance in the ranking.
%
%   Parameters:
%	db: A tests_db object.
%	row: A row index to match.
%	props: A structure with any optional properties.
%	  distDB: Take the standard deviation and covariance of this db instead.
%		
%   Returns:
%	crit_db: A tests_db with two rows for values and STDs.
%
%   Example:
%	>> crit_db = matchingRow(phys_control_compare_db, 
%		find(phys_control_compare_db(:, 'TracesetIndex') == 61))
%
% See also: rankMatching, tests_db, tests2cols
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/08

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props')
  props = struct;
end

tests = ':';

% Get the selected row in a DB
cols = tests2cols(db, tests);
crit_db = onlyRowsTests(db, row, tests);
crit_tests = getColNames(crit_db);

%# Check for distDB
if isfield(props, 'distDB')
  dist_db = props.distDB;
else
  dist_db = db;
end

% Calculate covariance for using Mahalonobis distance
cov_db = cov(noNaNRows(dist_db(:, crit_tests)));

% add the covariance matrix into the props
crit_db = setProp(crit_db, 'cov', cov_db);

%# Add the row index
crit_db = addColumns(crit_db, {'RowIndex'}, row);

%# Add the STD row, calculating from cov_db
crit_db = addLastRow(crit_db, [ sqrt(diag(get(cov_db, 'data')))', 0 ]);

%# Adjust other fields
crit_db = set(crit_db, 'row_idx', makeIdx({'Values', 'STD'}));
crit_db = set(crit_db, 'id', ['Criterion for matching row ' num2str(row) ...
			      ' from ' db.id ]);
