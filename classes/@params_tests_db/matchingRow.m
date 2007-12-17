function crit_db = matchingRow(a_db, row, props)

% matchingRow - Creates a criterion database for matching the tests of a row.
%
% Usage:
% crit_db = matchingRow(a_db, row, props)
%
% Description:
%   Overloaded method for skipping parameter values. STD for param values will be NaNs.
%
%   Parameters:
%	a_db: A tests_db object.
%	row: A row index to match.
%	props: A structure with any optional properties.
%		distDB: Take the standard deviation from this db instead.
%		
%   Returns:
%	crit_db: A tests_db with two rows for values and STDs.
%
%   Example: see tests_db/matchingRow
%
% See also: tests_db/matchingRow, rankMatching, tests_db, tests2cols
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/06/13

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props')
  props = struct;
end

params_cols = 1:a_db.num_params;
tests_cols = (a_db.num_params+1):dbsize(a_db, 2);

if isfield(props, 'distDB')
  % Take params out of distDB, too
  % why?? need to check if its a params_tests_db and count its params and
  % columns 
  %props.distDB = onlyRowsTests(props.distDB, ':', tests_cols);
end

no_params_db = onlyRowsTests(a_db.tests_db, ':', tests_cols);

% Call parent method for getting the criterion w/o the params
crit_db = matchingRow(no_params_db, row, props);

% Create a new params_tests_db.
% Add the STD of param values as NaNs
crit_db = ...
    params_tests_db([ get(onlyRowsTests(a_db, row, params_cols), 'data'); ...
		     nan(1, a_db.num_params)], getColNames(a_db, params_cols), ...
		    get(crit_db, 'data'), getColNames(crit_db), ...
		    crit_db.id, crit_db.props);
