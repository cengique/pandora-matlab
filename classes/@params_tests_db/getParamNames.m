function col_names = getParamNames(db)

% getParamNames - Gets parameter column names.
%
% Usage:
% col_names = getParamNames(db)
%
% Description:
%   Convenience function that delegates to getColNames.
%
% Parameters:
%   db: A params_tests_db object.
%		
% Returns:
%   col_names: A cell array of strings.
%
% See also: tests_db/getColNames, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2008/04/03

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

col_names = ...
    getColNames(onlyRowsTests(db, 1, 1:get(db, 'num_params')));
