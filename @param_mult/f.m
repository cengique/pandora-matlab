function y = f(a_ps, x)

% f - Evaluates the function at point x.
%
% Usage:
%   y = f(a_ps, x)
%
% Parameters:
%   a_ps: A param_func object.
%   x: Input to the function.
%		
% Returns:
%   y: The value of the function at x.
%
% Description:
%
% Example:
%   >> y = f(a_ps, 5)
%
% See also: param_func
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2009/12/09

% Copyright (c) 2009 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

y = feval(get(a_ps, 'func'), a_ps.f, getParamsStruct(a_ps.param_func), x);