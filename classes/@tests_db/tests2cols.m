function cols = tests2cols(db, tests)

% tests2cols - Find column numbers from a test names/numbers specification.
%
% Usage:
% cols = tests2cols(db, tests)
%
%   Parameters:
%	db: A tests_db object.
%	tests: Either a single or array of column numbers, or a single
%		test name or a cell array of test names. If ':', all
%		tests. For name strings, regular expressions are
%		supported if quoted with slashes (e.g., '/a.*/'). 
%		See tests2idx for more.
%		
%   Returns:
%	cols: Array of column indices.
%
% Description:
%   Uses tests2idx.
%
% See also: tests_db, tests2idx
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/07

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

cols = tests2idx(db, 'col', tests);
