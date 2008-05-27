function obj = onlyRowsTests(obj, varargin)

% onlyRowsTests - Returns a tests_db that only contains the desired 
%		tests and rows (and pages).
%
% Usage:
% obj = onlyRowsTests(obj, rows, tests, pages)
%
% Description:
% Selects the given dimensions and returns in a new tests_db
% object. Makes sure num_params remains correct.
%
%   Parameters:
%	obj: A tests_db object.
%	rows, tests: A logical or index vector of rows, or cell array of
%		names of rows. If ':', all rows. For names, regular expressions are
%		supported if quoted with slashes (e.g., '/a.*/'). See tests2idx.
%	pages: (Optional) A logical or index vector of pages. ':' for all pages.
%		
%   Returns:
%	obj: The new tests_db object.
%
% See also: subsref, tests_db, test2idx
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/17

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Adjust the number of parameters and then delegate the filtering to 
% tests_db/onlyRowsTests
if length(varargin) > 1
  cols = tests2cols(obj, varargin{2});
  cols = cols(:); % make column vector
  
  % find selected param cols
  param_col_idx = cols <= obj.num_params;
  
  % always keep params at the beginning
  varargin{2} = [cols(param_col_idx); cols(~param_col_idx)];
  
  % fix number of total params
  obj = set(obj, 'num_params', sum(param_col_idx));
end
obj.tests_db = onlyRowsTests(obj.tests_db, varargin{:});
