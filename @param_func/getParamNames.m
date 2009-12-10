function param_names = getParamNames(a_ps)

% getParamNames - Gets the parameter names of function.
%
% Usage:
%   param_names = getParamNames(a_ps)
%
% Parameters:
%   a_ps: A param_func object.
%		
% Returns:
%   param_names: Cell of parameter names.
%
% Description:
%
% Example:
%   >> param_names = getParamNames(a_ps)
%
% See also: param_func
%
% $Id: func.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2009/12/09

% Copyright (c) 2009 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

param_names = getColNames(a_ps);
