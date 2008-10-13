function [a_db, varargout] = processDimNonNaNInf(a_db, dim, a_func, a_func_name)

% processDimNonNaNInf - Recursively process the specified dimension with the desired function after removing NaNs and Infs.
%
% Usage:
% [a_db, n] = processDimNonNaNInf(a_db, dim, a_func, a_func_name)
%
% Parameters:
%   a_db: A tests_db object.
%   dim: Work down dimension (see mean).
%   a_func: A function name or handle to be passed to feval that
%	takes the data as the first argument and dimension to
%	work as second.
%   a_func_name: (Optional) A name to add to the id of a_db.
%		
% Returns:
%   a_db: The DB with one row of max values, with selected dimension
%	replaced by the output of the given function.
%   n: (Optional) Numbers of used values in each call of a_func.
%
% Description:
%   Does a recursive operation over other dimensions in order to remove
% NaN and Inf values. This takes more time than applying the function directly. 
%
% Example:
% a_db = tests_3D_db(rand(5, 5, 5));
% >> b_db = processDimNonNaNInf(a_db, 1, 'mean')
% will find the mean of rows in each page of the random 3D matrix.
% >> b_db = processDimNonNaNInf(a_db, 1, @(x,y)(max(x, [], y)), 'max')
% more complex function form with 'max'.
%
% See also: max, mean, feval, tests_db
%
% $Id: mean.m 909 2008-01-10 05:08:34Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2008/05/27

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

  if ~ exist('dim', 'var')
    dim = 1; % Go down rows by default
  end

  if ~ exist('a_func_name')
    if isa(a_func, 'function_handle')
      a_func_name = func2str(a_func);
    elseif ischar(a_func)
      a_func_name = a_func;
    else
      a_func_name = '<unknown operation>';
    end
      
  end

  % Always process row-wise: permute dimensions before and after processing.
  order = 1:length(dbsize(a_db));
  if dim ~= 1
    order(dim) = 1;
    order(1) = dim;
    data = permute(a_db.data, order);
  else
    data = a_db.data;
  end

  % Allocate results array
  db_size = size(data);
  s = repmat(NaN, [1 db_size(2:end)]);
  
  % Do a loop over EACH other dimension (!)
  [s, n] = processRecurseRowsNonNaNInf(data, length(db_size), ...
                                       a_func);
  
  if dim ~= 1
    s = ipermute(s, order);
  end

  a_db = set(a_db, 'id', [ a_func_name ' of ' get(a_db, 'id') ]);
  a_db = set(a_db, 'data', s);

  nout = max(nargout,1) - 1;

  % put optional output argument
  if nout > 0
    varargout{1} = n;
  end
