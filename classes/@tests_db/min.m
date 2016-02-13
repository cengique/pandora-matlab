function [a_db, varargout] = min(a_db, dim)

% min - Returns the min of the data matrix of a_db. Ignores NaN and Inf values.
%
% Usage:
% [a_db, n, i] = min(a_db, dim)
%
% Parameters:
%   a_db: A tests_db object.
%   dim: Work down dimension.
%		
% Returns:
%   a_db: The DB with one row of min values.
%   n: (Optional) Numbers of non-NaN rows included in calculating
%	each column.
%   i: Indices where the value was found.
%
% Description:
%   Does a recursive operation over dimensions in order to remove NaN and
% Inf values. This takes more time than a straightforward min operation. 
%
% See also: min, max, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/06

% Copyright (c) 2007-14 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

  % Go down rows by default
  dim = defaultValue('dim', 1);

  varargout = {};
  
  [a_db, n, i] = ...
      processDimNonNaNInf(a_db, dim, @(x,y)(min(x, [], y)), 'Min');

  nout = min(nargout,1) - 1;
  if nout > 0
    varargout{1} = n;
    if nout > 1
      varargout{2} = i;
    end
  end
