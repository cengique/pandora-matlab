function [a_db, varargout] = max(a_db, dim)

% max - Returns the max of the data matrix of a_db. Ignores NaN and Inf values.
%
% Usage:
% [a_db, n] = max(a_db, dim)
%
% Parameters:
%	a_db: A tests_db object.
%	dim: Work down dimension.
%		
% Returns:
%	a_db: The DB with one row of max values.
%	n: (Optional) Numbers of non-NaN rows included in calculating each column.
%
% Description:
%   Does a recursive operation over dimensions in order to remove NaN and
% Inf values. This takes more time than a straightforward max operation. 
%
% See also: max, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/06

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

  % Go down rows by default
  dim = defaultValue('dim', 1);

  [a_db, varargout] = processDimNonNaNInf(a_db, dim, @(x,y)(max(x, [], y)), 'Max');