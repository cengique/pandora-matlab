function param_names = paramNames(traceset, item)

% paramNames - Returns the parameter names for this traceset.
%
% Usage:
% param_names = paramNames(traceset)
%
% Description:
% Looks at the filename of the first file to find the parameter names.
%
%   Parameters:
%	traceset: A params_tests_dataset.
%		
%   Returns:
%	param_names: Cell array with ordered parameter names.
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
% http://opensource.org/licenses/afl-3.0.txt.

if ~ exist('item')
  item = 1;
end

%# CIP magnitude in pA
param_names = { 'pulseOn', 'pulseOff', 'traceEnd' 'pAcip', 'pAbias' };
%# Add treatment names
if length(fieldnames(traceset.treatments)) > 0
	param_names = cat(2, param_names, fieldnames(traceset.treatments)');
end
