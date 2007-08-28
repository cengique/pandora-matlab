function crit_db = matchingRow(a_bundle, row, props)

% matchingRow - Creates a criterion database for matching the tests of a row.
%
% Usage:
% crit_db = matchingRow(a_bundle, row, props)
%
% Description:
%   Copies selected test values from row as the first row into the 
% criterion db. Adds a second row for the STD of each column in the db.
%
%   Parameters:
%	a_bundle: A tests_db object.
%	row: A row index to match.
%	props: A structure with any optional properties.
%		distDB: Take the standard deviation from this db instead.
%		
%   Returns:
%	crit_db: A tests_db with two rows for values and STDs.
%
%   Example:
%	physiol_bundle has an overloaded matchingRow method that
%	takes the TracesetIndex as argument:
%	>> crit_db = matchingRow(pbundle, 61)
%
% See also: rankMatching, tests_db, tests2cols
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/12/21

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props')
  props = struct;
end

crit_db = matchingRow(get(a_bundle, 'joined_db'), row, props);
