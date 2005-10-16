function makeGenesisParFile(a_db, filename)

% makeGenesisParFile - Creates a Genesis parameter file with all the parameter values in a_db.
%
% Usage:
% makeGenesisParFile(a_db, filename)
%
% Description:
%   For each a_db row, print the parameter names in a
% file formatted for Genesis.
%
%   Parameters:
%	a_db: A params_tests_db object.
%	filename: Genesis parameter file to be created.
%
%   Returns:
%	nothing.
%
%   Example:
%	>> blocked_rows_db = getBlockedParamRows(ranked_for_gps0501a_db, 1, [1, 2], 10, [-100 100]);
%	>> makeGenesisParFile(blocked_rows_db, 'blocked_gps0501-03.par')
%
% See also: params_tests_db/getBlockedParamRows
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/03/13

%# TODO: read paramRanges.txt to verify parameter sequence

num_rows = dbsize(a_db, 1);

%# First row of par file contains info
first_row = [ num2str(num_rows) ' ' num2str(a_db.num_params) sprintf('\n') ];

%# Rest contains param values and zeros appended at the end of row
data_rows = [num2str( [get(onlyRowsTests(a_db, ':', 1:a_db.num_params), 'data'), ...
			   zeros(num_rows, 1) ]), ...
	     repmat(sprintf('\n'), num_rows, 1) ];

data_str = reshape(data_rows', 1, prod(size(data_rows)));

string2File([first_row, data_str], filename);
