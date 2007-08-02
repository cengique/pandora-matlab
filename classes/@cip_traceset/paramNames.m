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

%# CIP magnitude in pA
param_names = { 'pAcip' };