function obj = delColumns(obj, tests)

% delColumns - Deletes columns from tests_db.
%
% Usage:
% index = delColumns(obj, tests)
%
% Description:
%   Overloaded function that maintains correct number of parameters. See
% original tests_db/delColumns.
%
%   Parameters:
%	obj: A tests_db object.
%	tests: Numbers or names of tests (see tests2cols)
%		
%   Returns:
%	obj: The tests_db object that is missing the columns.
%
% See also: tests_db/delColumns
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/10/11

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

cols = sort(tests2cols(obj, tests));
obj.tests_db = delColumns(obj.tests_db, tests);
obj.num_params = obj.num_params - sum(cols <= obj.num_params);
