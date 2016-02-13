function a_tests_3D_db = groupBy(db, cols)

% groupBy - Groups same values of column(s) into separate pages of a 3D db.
%
% Usage:
% a_tests_3D_db = groupBy(db, cols)
%
% Parameters:
%   db: A tests_db object.
%   cols: Columns whose same values will be in one page (see tests2cols
%   	  for column representation).
%		
% Returns:
%	a_tests_3D_db: A tests_3D_db object of organized values.
%
% Description:
%   Functionality similar to SQL's GROUP BY keyword. This function
% uses invarValues, but resulting pages will not be sorted.
%
% Example:
% >> a_db = tests_db([ ... ], {'par1', 'par2', 'measure1', 'measure2'})
% % make a page for each value of par1, and list par2 values with assoc. measures:
% >> a_3d_db = groupBy(a_db, 'par1')
% >> % get back other columns:
% >> joined_3d_db = joinRows(a_db, a_3d_db)
% >> displayRows(joined_3d_db(:, :, 1))
%
% See also: invarValues, tests_3D_db, tests_3D_db/corrCoefs, tests_3D_db/plotPair,
% 	    joinRows, tests_3D_db/swapRowsPages, tests_3D_db/mergePages
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2008/05/27

% Copyright (c) 2007-2008 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

col_ids = tests2cols(db, cols);
all_col_names = getColNames(db);
col_names = all_col_names(col_ids);

% select all except chosen ones
all_cols = true(1, length(all_col_names));
all_cols(col_ids) = false;

% delegate to invarValues
a_tests_3D_db = invarValues(db, all_cols, cols, struct('sortPages', 0));
