function param_names = paramNames(fileset)

% paramNames - Returns the only parameter, 'pAcip,' for this fileset.
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
%	params_names: Cell array with ordered parameter names.
%
% See also: params_tests_fileset, paramNames, testNames
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/06

%# CIP magnitude in pA
param_names = { 'NeuronId', 'pAcip' };