function f_handle = fHandle(a_ps)

% fHandle - Return a handle to function with fixed parameters.
%
% Usage:
%   f_handle = fHandle(a_ps)
%
% Parameters:
%   a_ps: A param_func object.
%		
% Returns:
%   f_handle: Handle to compiled function that can evaluate f_handle(x).
%
% Description:
%   Specialized fHandle for param_spline_func. Much faster spline
% evaluation because spline coefficients are only calculated once.
%
% Example:
%   >> f_h = fHandle(a_ps)
%   >> a = f_h(x)
%
% See also: param_func, function_handle
%
% $Id: fHandle.m 88 2010-04-08 17:41:24Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/09/16

% Copyright (c) 2009-2010 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% calculate function and parameters
pp = pchip(a_ps.x_vals, getParams(a_ps));

% return as new handle
f_handle = @(x) ppval(pp, x);
