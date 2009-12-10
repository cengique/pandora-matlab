function [y dy] = fp(a_ps, p, x)

% fp - Evaluates the function at point x for given parameters, p.
%
% Usage:
%   [y dy] = fp(a_ps, p, x)
%
% Parameters:
%   a_ps: A param_func object.
%   p: Vector of parameters.
%   x: Input to the function.
%		
% Returns:
%   y, dy: The value and time derivative (optional) of the function at x.
%
% Description:
%
% Example:
%   >> y = fp(a_ps, [2 4], 5)
%
% See also: param_func
%
% $Id: fp.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2009/12/09

% Copyright (c) 2009 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

[y, dy] = f(setParams(a_ps, p), x);