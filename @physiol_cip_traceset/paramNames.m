function param_names = paramNames(fileset)

% paramNames - Returns the parameter names for this fileset.
%
% Usage:
% param_names = paramNames(fileset)
%
% Description:
% Looks at the filename of the first file to find the parameter names.
%
%   Parameters:
%	fileset: A params_tests_fileset.
%		
%   Returns:
%	param_names: Cell array with ordered parameter names.
%
% See also: params_tests_fileset, paramNames, testNames
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/06

%# CIP magnitude in pA
param_names = { 'pulseOn', 'pulseOff', 'traceEnd' 'pAcip', 'pAbias' };
%# Add treatment names
if length(fieldnames(fileset.treatments)) > 0
	param_names = cat(2, param_names, fieldnames(fileset.treatments)');
end
