function [s, n] = processRecurseRowsNonNaNInf(data, dim_num, a_func)

% processRecurseRowsNonNaNInf - Recursively process from dim_num down to row dimension and call function after removing NaN and Infs.
%
% Usage:
% [s, n] = processRecurseRowsNonNaNInf(data, dim_num, a_func)
%
% Parameters:
%   a_db: A tests_db object.
%   dim_num: Work down dimension (see mean).
%   a_func: A function name or handle to be passed to feval that
%	takes the data as the first argument and dimension to work as second.
%		
% Returns:
%   s: Resulting data matrix, with selected dimension removed.
%   n: Numbers of used values in each call of a_func.
%
% Description:
%   Does a recursive operation over other dimensions in order to remove
% NaN and Inf values. This takes more time than applying the function directly. 
%
% Example:
% >> b = processRecurseRowsNonNaNInf(rand(5, 5, 5), 1, 'mean')
% will find the mean of rows in each page of the random 3D matrix.
%
% See also: processDimNonNaNInf, max, mean, feval, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2008/05/27

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

  if dim_num == 1
    sdata = data(~isnan(data(:)) & ~isinf(data(:)));
    n = size(sdata, 1);
    if n == 0
      % If a divide by zero error occured, 
      % give it NaN value instead of an empty matrix.
      s = NaN;
    else
      s = feval(a_func, sdata, 1);
    end
  else
    for num=1:size(data, dim_num)
      % Otherwise recurse
      [dims{1:(dim_num-1)}] = deal(':');
      dims{dim_num} = num;
      [s(dims{:}) n(dims{:})] = ...
          processRecurseRowsNonNaNInf(data(dims{:}), dim_num - 1, a_func);
    end
  end

