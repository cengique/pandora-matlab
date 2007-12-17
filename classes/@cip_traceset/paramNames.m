function param_names = paramNames(traceset)

% paramNames - Returns the only parameter, 'pAcip,' for this traceset.
%
% Usage:
% param_names = paramNames(traceset)
%
% Description:
% Looks at the filename of the first file to find the parameter names.
%
%   Parameters:
%	traceset: A cip_traceset.
%		
%   Returns:
%	params_names: Cell array with ordered parameter names.
%
% See also: params_tests_dataset, paramNames, testNames
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/06

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% CIP magnitude in pA
param_names = { 'pAcip' };